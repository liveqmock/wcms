<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>设计方案录入</title>
<link id="easyuiTheme" href="<%=request.getContextPath()%>/themes/metro/easyui.css" rel="stylesheet" type="text/css" />
<link href="<%=request.getContextPath()%>/themes/icon.css" rel="stylesheet" type="text/css" />
<script src="<%=request.getContextPath()%>/js/jquery.min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/jquery.easyui.min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/easyui-lang-zh_CN.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/outlook2.js" type="text/javascript"></script>

<script type="text/javascript">
	$(function(){
		var seeStatus = $('#seeStatus').val();
		
		$('.datebox').datebox({
			editable:false
		});
		
		$('#designList').datagrid({
			url: '<%=request.getContextPath()%>/design/getAuditDesignList?seeStatus='+seeStatus,
			title: '设计方案列表',
			toolbar:[
				{iconCls : 'icon-search', text : '查看', 
					handler: function(){
						var data = $('#designList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要查看的数据' , 'warning');
					 		return;
					 	}
						
						viewDesign(data);
					}
				},
				{iconCls : 'icon-search', text : '审批', 
					handler: function(){
						var data = $('#designList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要审批的数据' , 'warning');
					 		return;
					 	}
						
						if(data.status == seeStatus){
							auditDesign(data);	
						}else{
							msgShow('提示', '只能审批未审批的设计方案' , 'warning');
						}
					}
				},
				{iconCls : 'icon-ok', text : '通过', 
					handler: function(){
						var data = $('#designList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要编辑的数据' , 'warning');
					 		return;
					 	}
						
						if(data.status == seeStatus){
							submitAudit(data, 1);
						}else{
							msgShow('提示', '只能审批未审批的订单' , 'warning');
						}
					}
				}
			],
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			pagination:true,
			columns:[[
				{field:'id', title:'',width:10, 
					formatter:function(value, rowData, rowIndex){
						if(rowData.status == seeStatus){
							return '<div style="width:10px;height:10px;background-color:yellow"></div>';
						}else if(rowData.status >= 30){
							return '<div style="width:10px;height:10px;background-color:blue"></div>';
						}
					}
				},
				{field:'orderNo',title:'合同编号',width:80},
				{field:'orderName',title:'项目名称',width:80},
				{field:'clientName',title:'客户名称',width:80},
				{field:'name',title:'产品名称',width:80},
				{field:'model',title:'规格型号',width:80},
				{field:'quantity',title:'数量',width:80},
				{field:'unitName',title:'单位',width:80},
				{field:'status',title:'状态',width:80,
					formatter:function(value, rowData, rowIndex){
						if(value == seeStatus){
							return "未审批";
						}else if(value > seeStatus){
							return "已审批";
						}
					}
				},
				{field:'techParam',title:'技术参数',width:120}
			]],
			onDblClickRow:function(rowIndex, rowData) {  
				viewProduct(); 
	        },
		});
		
		var p = $('#designList').datagrid('getPager'); 
		p.pagination({  
	        pageSize : 10,// 每页显示的记录条数，默认为20  
	        pageList : [ 10, 20, 30 ],// 可以设置每页记录条数的列表  
	        beforePageText : '第',// 页数文本框前显示的汉字  
	        afterPageText : '页    共 {pages} 页',  
	        displayMsg : '当前显示 {from} - {to} 条记录   共 {total} 条记录'   
	    });
		
		$('#search-status').combobox({
			data:[{'id':0,'text':'未审批'},
			      {'id':1,'text':'已审批'}
			     ],
			valueField:'id',
			textField:'text',
			editable:false
		});
		
		$('#search-status').combobox('select', 0);
		
		$('#search').on('click', function(){
			
			var queryParams = {};
			var params = $('.queryParam');
			for(i=0;i<params.length;i++){
				if($(params[i]).val() != ''){
					queryParams[$(params[i]).attr('name')] = $(params[i]).val();
				}
			}
			
			var status = $('#search-status').combobox('getValue');
			queryParams.auditStatus = status;
			
			$('#designList').datagrid('options').queryParams = queryParams;
			$('#designList').datagrid('reload');
		});
		
		$('#viewWin').window({
            title: '查看',
            width: 1000,
            modal: true,
            shadow: true,
            closed: true,
            height: 550,
            top:0,
            left:50
        });
		
		$('#auditWin').window({
            title: '审批',
            width: 1000,
            modal: true,
            shadow: true,
            closed: true,
            height: 550,
            top:0,
            left:50
        });
		
		$('#audit-pass').on('click', function(){
			var data = {"id":$('#auditDesignId').val()};
			if(!strIsNull($('#auditComment').val())){
				data.comment = $('#auditComment').val();
			}else{
				data.comment = "";
			}
			submitAudit(data, 1);
			$('#auditWin').window('close');
		});
		
		$('#audit-cancel').on('click', function(){
			var data = {"id":$('#auditDesignId').val()};
			
			if(strIsNull($('#auditComment').val())){
				msgShow('提示', '退回必须填写原因' , 'warning');
				return;
			}
			data.comment = $('#auditComment').val();
			submitAudit(data, 0);
			$('#auditWin').window('close');
		});
		
		$('#auditForm').form({
			url:'<%=request.getContextPath()%>/design/submitAudit',
			onSubmit:function(){
				
			},
			success:function(data){
				var data = eval('(' + data + ')');
				MaskUtil.unmask();
				if(data.flag){
					$('#designList').datagrid('reload');
					msgShow('提示', '提交成功' , 'info');
				}else{
					msgShow('提示', '提交失败' , 'error');
				}
			}
		});
	});
	
	//查看
	function viewDesign(data){
		$('#viewOrderNo').html(data.orderNo);
		$('#viewName').html(data.name);
		$('#viewQuantity').html(data.quantity);
		$('#viewUnit').html(data.unitName);
		$('#viewModel').html(data.model);
		$('#viewTechParam').html(data.techParam);
		
		/**
		$('#viewMaterialList').datagrid({
			url: '<%=request.getContextPath()%>/design/getMaterList?id='+data.id,
			title:'材料清单',
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			pagination:true,
			columns:[[
				{field:'name',title:'名称',width:80},
				{field:'model',title:'规格',width:80},
				{field:'density',title:'理论密度(Kg/单位)',width:80, align:'right'},
				{field:'caculationsBase',title:'计算基数',width:40, align:'right'},
				{field:'unitName',title:'单位',width:40},
				{field:'singleQuantity',title:'单台材料质量(Kg)',width:80, align:'right'},
				{field:'amount',title:'数量(台)',width:40, align:'right'},
				{field:'totalQuantity',title:'材料总质量(Kg)',width:80, align:'right'},
				{field:'remark',title:'备注',width:80}
			]]
		});
		
		var productPage = $('#viewMaterialList').datagrid('getPager'); 
		productPage.pagination({  
	        pageSize : 10,// 每页显示的记录条数，默认为20  
	        pageList : [10],// 可以设置每页记录条数的列表  
	        beforePageText : '第',// 页数文本框前显示的汉字  
	        afterPageText : '页    共 {pages} 页',  
	        displayMsg : '当前显示 {from} - {to} 条记录   共 {total} 条记录'   
	    });
		*/
		$('#viewDrawingList').datagrid({
			url: '<%=request.getContextPath()%>/design/getAttaList?id='+data.id,
			title:'图纸清单',
			toolbar:[
				{iconCls : 'icon-ok', text : '下载', 
					handler: function(){
						var data = $('#viewDrawingList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要下载的附件' , 'warning');
					 		return;
					 	}
						window.open('<%=request.getContextPath()%>/design/downloadAtta?attaId='+data.id);
					}
				}
			],
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			pagination:false,
			columns:[[
				{field:'fileName',title:'图纸名称',width:80}
			]]
		});
		
		$('#viewAuditLogList').datagrid({
			url: '<%=request.getContextPath()%>/audit/getAuditList?id='+data.id+'&type=3',
			title:'审批记录',
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			pagination:false,
			columns:[[
				{field:'userDept',title:'部门',width:40},
				{field:'userName',title:'审批人',width:40},
				{field:'auditDate',title:'审批时间',width:40},
				{field:'comment',title:'审批意见',width:380},
				{field:'ioption',title:'操作',width:20, 
					formatter: function(value, rowData, rowIndex){
						return value==1?"通过":"退回";
					}
				},
			]]
		});
		
		$('#viewWin').window('open'); 
	}
	
	function auditDesign(data){
		$('#auditDesignId').val(data.id);
		
		$('#auditOrderNo').html(data.orderNo);
		$('#auditName').html(data.name);
		$('#auditQuantity').html(data.quantity);
		$('#auditUnit').html(data.unitName);
		$('#auditModel').html(data.model);
		$('#auditTechParam').html(data.techParam);
		
		/**
		$('#auditMaterialList').datagrid({
			url: '<%=request.getContextPath()%>/design/getMaterList?id='+data.id,
			title:'材料清单',
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			pagination:true,
			columns:[[
				{field:'name',title:'名称',width:80},
				{field:'model',title:'规格',width:80},
				{field:'density',title:'理论密度(Kg/单位)',width:80, align:'right'},
				{field:'caculationsBase',title:'计算基数',width:40, align:'right'},
				{field:'unitName',title:'单位',width:40},
				{field:'singleQuantity',title:'单台材料质量(Kg)',width:80, align:'right'},
				{field:'amount',title:'数量(台)',width:40, align:'right'},
				{field:'totalQuantity',title:'材料总质量(Kg)',width:80, align:'right'},
				{field:'remark',title:'备注',width:80}
			]]
		});
		
		var productPage = $('#auditMaterialList').datagrid('getPager'); 
		productPage.pagination({  
	        pageSize : 10,// 每页显示的记录条数，默认为20  
	        pageList : [10],// 可以设置每页记录条数的列表  
	        beforePageText : '第',// 页数文本框前显示的汉字  
	        afterPageText : '页    共 {pages} 页',  
	        displayMsg : '当前显示 {from} - {to} 条记录   共 {total} 条记录'   
	    });
		*/
		
		$('#auditDrawingList').datagrid({
			url: '<%=request.getContextPath()%>/design/getAttaList?id='+data.id,
			title:'图纸清单',
			toolbar:[
				{iconCls : 'icon-ok', text : '下载', 
					handler: function(){
						var data = $('#auditDrawingList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要下载的附件' , 'warning');
					 		return;
					 	}
						window.open('<%=request.getContextPath()%>/design/downloadAtta?attaId='+data.id);
					}
				}
			],
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			pagination:false,
			columns:[[
				{field:'fileName',title:'图纸名称',width:80}
			]]
		});
		
		$('#auditAuditLogList').datagrid({
			url: '<%=request.getContextPath()%>/audit/getAuditList?id='+data.id+'&type=3',
			title:'审批记录',
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			pagination:false,
			columns:[[
				{field:'userDept',title:'部门',width:40},
				{field:'userName',title:'审批人',width:40},
				{field:'auditDate',title:'审批时间',width:40},
				{field:'comment',title:'审批意见',width:380},
				{field:'ioption',title:'操作',width:20, 
					formatter: function(value, rowData, rowIndex){
						return value==1?"通过":"退回";
					}
				},
			]]
		});
		
		$('#auditWin').window('open');
	}
	
	function submitAudit(data, option){
		MaskUtil.mask();
		data.seeStatus = $('#seeStatus').val();
		$('#auditForm').form('load', data);
		$('#auditOption').val(option);
		$('#auditForm').submit();
	}
</script>
</head>
<body>
	<input id="seeStatus" type="hidden" value="${seeStatus}"/>
	<table style="width:100%;height:auto;border: 1px solid #ccc; font-size: 12px;color: #888;padding: 5px;">
		<tr>
			<td style="text-align: right;">
				合同编号：
			</td>
			<td style="text-align: left;">
				<input class="queryParam" name="orderNo" style="width: 75%; height: 17px;"/>
			</td>
			<td style="text-align: right;">
				产品名称：
			</td>
			<td style="text-align: left;">
				<input class="queryParam" name="name" style="width: 75%; height: 17px;"/>
			</td>
			<td style="text-align: right;">
				状态：
			</td>
			<td style="text-align: left;">
				<input id="search-status" style="width: 150px; height: 23px;"/>
				<input type="hidden" class="queryParam" id="search-auditStatus" name="auditStatus">
			</td>
			<td style="text-align: right;">
				规格型号：
			</td>
			<td style="text-align: left;">
				<input class="queryParam" name="model" style="width: 75%; height: 17px;"/>
			</td>
		</tr>
		<tr>
			<td style="text-align: right;">
				
			</td>
			<td style="text-align: left;">
				
			</td>
			<td style="text-align: left;">
				
			</td>
			<td style="text-align: left;">
				
			</td>
			<td style="text-align: right;">
				
			</td>
			<td style="text-align: left;">
				
			</td>
			<td style="text-align: center;" colspan="2">
				<a id="search" class="easyui-linkbutton" style="height: 25px;" iconCls="icon-search">搜索</a>
			</td>
		</tr>
	</table>
	<div style="height: 10px;"></div>
	<table id="designList"></table>
	
	<div id="viewWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-search">
    	  <table style="width: 100%;">
    	  	<tr style="line-height: 25px;">
    	  		<td style="width: 8%; text-align: right;">合同编号：</td>
    	  		<td style="width: 15%; text-align: left;" id="viewOrderNo"></td>
    	  		
    	  		<td style="width: 8%; text-align: right;">产品名称：</td>
    	  		<td style="width: 15%; text-align: left;" id="viewName"></td>
    	  		
    	  		<td style="width: 8%; text-align: right;">数量：</td>
    	  		<td style="width: 8%; text-align: left;" id="viewQuantity"></td>
    	  		
    	  		<td style="width: 8%; text-align: right;">单位：</td>
    	  		<td style="width: 8%; text-align: left;" id="viewUnit"></td>
    	  	</tr>
    	  	
    	  	<tr>
    	  		<td style="width: 8%; text-align: right;">规格型号：</td>
    	  		<td style="width: 15%; text-align: left;" id="viewModel"></td>
    	  		
    	  		<td style="width: 8%; text-align: right;">技术参数：</td>
    	  		<td style="width: 15%; text-align: left;" id="viewTechParam"></td>
    	  	</tr>
    	  </table>
    	  
    	<table id="viewMaterialList"></table>
    	<div style="height: 10px;"></div>
    	<table id="viewDrawingList"></table>
    	<div style="height: 10px;"></div>
    	<table id="viewAuditLogList"></table> 
  	</div>
  	
  	<div id="auditWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-search">  
         <input type="hidden" id="auditDesignId">
    	  <table style="width: 100%;">
    	  	<tr style="line-height: 25px;">
    	  		<td style="width: 8%; text-align: right;">合同编号：</td>
    	  		<td style="width: 15%; text-align: left;" id="auditOrderNo"></td>
    	  		
    	  		<td style="width: 8%; text-align: right;">产品名称：</td>
    	  		<td style="width: 15%; text-align: left;" id="auditName"></td>
    	  		
    	  		<td style="width: 8%; text-align: right;">数量：</td>
    	  		<td style="width: 8%; text-align: left;" id="auditQuantity"></td>
    	  		
    	  		<td style="width: 8%; text-align: right;">单位：</td>
    	  		<td style="width: 8%; text-align: left;" id="auditUnit"></td>
    	  	</tr>
    	  	
    	  	<tr>
    	  		<td style="width: 8%; text-align: right;">规格型号：</td>
    	  		<td style="width: 15%; text-align: left;" id="auditModel"></td>
    	  		
    	  		<td style="width: 8%; text-align: right;">技术参数：</td>
    	  		<td style="width: 15%; text-align: left;" id="auditTechParam"></td>
    	  	</tr>
    	  </table>
    	  
    	<table id="auditMaterialList"></table>
    	<div style="height: 10px;"></div>
    	<table id="auditDrawingList"></table>
    	<div style="height: 10px;"></div>
    	<table id="auditAuditLogList"></table>
    	
    	<table style="width: 100%;">
    		<tr>
    			<td style="width: 70%;">
    				<textarea rows="4" cols="110" id="auditComment"></textarea>
    			</td>
    			<td style="text-align: left;width: 30%;">
    				<a id="audit-pass" class="easyui-linkbutton" iconCls="icon-ok">通过</a>
    				<a id="audit-cancel" class="easyui-linkbutton" iconCls="icon-cancel">退回</a>
    			</td>
    		</tr>
    	</table>
    	<form action="#" id="auditForm" method="post">
    		<input type="hidden" name="id">
    		<input type="hidden" id="auditOption" name="option">
    		<input type="hidden" name="seeStatus">
    		<input type="hidden" name="comment">
    	</form> 
  	</div>
</body>
</html>