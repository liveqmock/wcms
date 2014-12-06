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
		$('.datebox').datebox({
			editable:false
		});
		
		$.extend($.fn.validatebox.defaults.rules, {
		    nums: {
		        validator: function(value){
		        	var reg = new RegExp("^[0-9]+(.[0-9]+)?$");
		            return reg.test(value);
		        },
		        message: '请输入数字'
		    }
		});
		
		$('#designList').datagrid({
			url: '<%=request.getContextPath()%>/design/getDesignList',
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
				{iconCls : 'icon-edit', text : '编辑', 
					handler: function(){
						var data = $('#designList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要编辑的数据' , 'warning');
					 		return;
					 	}
						
						if(data.status == 0 || data.status == -5555){
							editDesign(data);
						}else{
							msgShow('提示', '只能编辑未提交或退回的设计方案' , 'warning');
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
						if(rowData.status == 0 || rowData.status == -5555){
							return '<div style="width:10px;height:10px;background-color:red"></div>';	
						}else if(rowData.status == 10 || rowData.status == 20 || rowData.status == 25){
							return '<div style="width:10px;height:10px;background-color:yellow"></div>';
						}else if(rowData.status == 30){
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
						if(value == 0){
							return "未提交";
						}else if(value == 10){
							return "审批中";
						}else if(value == 30){
							return "已生效";
						}else if(value == -5555){
							return "退回";
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
		
		$('#editWin').window({
            title: '编辑',
            width: 1000,
            modal: true,
            shadow: true,
            closed: true,
            height: 550,
            top:0,
            left:50
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
		
		$('#addMaterWin').window({
			title: '添加物料',
			width: 500,
			modal: true,
            shadow: true,
            closed: true,
            height: 550,
            top:0,
            left:300
		});
		
		$('#editMaterWin').window({
			title: '编辑物料',
			width: 500,
			modal: true,
            shadow: true,
            closed: true,
            height: 550,
            top:0,
            left:300
		});
		
		$('#addAttaWin').window({
			title: '添加附件',
			width: 500,
			modal: true,
            shadow: true,
            closed: true,
            height: 200,
            top:100,
            left:300
		});
		
		$('#search-status').combobox({
			data:[{'id':'-1', 'text':'全部'},{'id':-5555,'text':'退回'},
			      {'id':0,'text':'未提交'},{'id':10,'text':'审批中'},
			      {'id':30,'text':'已生效'}
			     ],
			valueField:'id',
			textField:'text',
			editable:false
		});
		
		$('#search-status').combobox('select', -1);
		
		$('#search').on('click', function(){
			
			var queryParams = {};
			var params = $('.queryParam');
			for(i=0;i<params.length;i++){
				if($(params[i]).val() != ''){
					queryParams[$(params[i]).attr('name')] = $(params[i]).val();
				}
			}
			
			var status = $('#search-status').combobox('getValue');
			if(status != -1){
				queryParams.status = status;	
			}
			
			$('#designList').datagrid('options').queryParams = queryParams;
			$('#designList').datagrid('reload');
		});
		
		$('#attaForm').form({
			url:'<%=request.getContextPath()%>/design/addAtta',
			onSubmit:function(){
				if($(this).form('validate')){
					MaskUtil.mask();
				}
				return $(this).form('validate');
			},
			success:function(data){
				MaskUtil.unmask();
				var data = eval('(' + data + ')');
				if(data.flag){
					msgShow('提示','上传成功','info');
					$('#editDrawingList').datagrid('reload');
					$('#addAttaWin').window('close');
					$('#attaFile').val('');
				}else{
					msgShow('提示','上传失败','error');
				}
			}
		});
		
		$('#atta_upload').on('click', function(){
			$('#attaForm').submit();
		});
		
		$('#addMaterForm').form({
			url:'<%=request.getContextPath()%>/design/saveMater',
			onSubmit:function(){
				if($(this).form('validate')){
					MaskUtil.mask();
				}
				return $(this).form('validate');
			},
			success:function(data){
				MaskUtil.unmask();
				var data = eval('(' + data + ')');
				if(data.flag){
					msgShow('提示','保存成功','info');
					$('#editMaterialList').datagrid('reload');
					$('#addMaterWin').window('close');
					$('#addMaterForm').form('reset');
				}else{
					msgShow('提示','保存失败','error');
				}
			}
		});
		
		$('#add-mater-save').on('click', function(){
			$('#addMaterForm').submit();
		});
		
		$('#editMaterForm').form({
			url:'<%=request.getContextPath()%>/design/updateMater',
			onSubmit:function(){
				if($(this).form('validate')){
					MaskUtil.mask();
				}
				return $(this).form('validate');
			},
			success:function(data){
				MaskUtil.unmask();
				var data = eval('(' + data + ')');
				if(data.flag){
					msgShow('提示','更新成功','info');
					$('#editMaterialList').datagrid('reload');
					$('#editMaterWin').window('close');
					$(this).form('reset');
				}else{
					msgShow('提示','更新失败','error');
				}
			}
		});
		
		$('#edit-mater-save').on('click', function(){
			$('#editMaterForm').submit();
		});
		
		$('#submit').on('click', function(){
			var data = {"id":$('#designId').val()};
			submitDesign(data);
			$('#editWin').window('close');
			$('#designList').datagrid('reload');
		});
	});
	
	//编辑设计方案
	function editDesign(data){
		$('#designId').val(data.id);
		
		$('#editOrderNo').html(data.orderNo);
		$('#editName').html(data.name);
		$('#editQuantity').html(data.quantity);
		$('#editUnit').html(data.unitName);
		$('#editModel').html(data.model);
		$('#editTechParam').html(data.techParam);
		
		/**
		$('#editMaterialList').datagrid({
			url: '<%=request.getContextPath()%>/design/getMaterList?id='+data.id,
			title:'物料清单',
			toolbar:[
				{iconCls : 'icon-add', text : '新增', 
					handler: function(){
						$('#addDesignId').val(data.id);
						$('#addMaterWin').window('open');
					}
				},
				{iconCls : 'icon-edit', text : '编辑', 
					handler: function(){
						var data = $('#editMaterialList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要编辑的数据' , 'warning');
					 		return;
					 	}
						
						$('#editMaterForm').form('load', data);
						$('#editMaterWin').window('open');
					}
				},
				{iconCls : 'icon-remove', text : '删除', 
					handler: function(){
						var data = $('#editMaterialList').datagrid('getSelected');
						if(data==null){
	 						msgShow('提示', '请选中需要提交的数据' , 'warning');
	 						return;
	 					}
						
						MaskUtil.mask();
						$.ajax({
		        			url:"<%=request.getContextPath()%>/design/deleteMater?id=" + data.id,
		    				type:"post",
		    				dataType:"json",
		    				success:function(data, textStatus){
		    					MaskUtil.unmask();
		    					if(data.flag){
		    						msgShow('提示','删除成功','info');
		    						$('#editMaterialList').datagrid('reload');
		    					}else{
		    						msgShow('提示','删除失败','error');
		    					}
		    				},
		    				error:function(){
		    					MaskUtil.unmask();
		    					msgShow('提示', '删除失败' , 'error');
		    				},
		    				async:false
		        		});
					}
				}
			],
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
				{field:'singleQuality',title:'单台材料质量(Kg)',width:80, align:'right'},
				{field:'amount',title:'数量(台)',width:40, align:'right'},
				{field:'totalQuantity',title:'材料总质量(Kg)',width:80, align:'right'},
				{field:'remark',title:'备注',width:80}
			]]
		});
		
		var productPage = $('#editMaterialList').datagrid('getPager'); 
		productPage.pagination({  
	        pageSize : 10,// 每页显示的记录条数，默认为20  
	        pageList : [10],// 可以设置每页记录条数的列表  
	        beforePageText : '第',// 页数文本框前显示的汉字  
	        afterPageText : '页    共 {pages} 页',  
	        displayMsg : '当前显示 {from} - {to} 条记录   共 {total} 条记录'   
	    });
		*/
		
		$('#editDrawingList').datagrid({
			url: '<%=request.getContextPath()%>/design/getAttaList?id='+data.id,
			title:'图纸清单',
			toolbar:[
			    {iconCls : 'icon-add', text : '添加', 
					handler: function(){
						$('#atta_designId').val(data.id);
						addAtta();
					}
				},
				{iconCls : 'icon-ok', text : '下载', 
					handler: function(){
						var data = $('#editDrawingList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要下载的附件' , 'warning');
					 		return;
					 	}
						window.open('<%=request.getContextPath()%>/design/downloadAtta?attaId='+data.id);
					}
				},
				{iconCls : 'icon-remove', text : '删除', 
					handler: function(){
						var data = $('#editDrawingList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要删除的附件' , 'warning');
					 		return;
					 	}
						MaskUtil.mask();
						$.ajax({
		        			url:"<%=request.getContextPath()%>/design/deleteAtta?attaId=" + data.id,
		    				type:"post",
		    				dataType:"json",
		    				success:function(data, textStatus){
		    					MaskUtil.unmask();
		    					if(data.flag){
		    						msgShow('提示','删除成功','info');
		    						$('#editDrawingList').datagrid('reload');
		    					}else{
		    						msgShow('提示','删除失败','error');
		    					}
		    				},
		    				error:function(){
		    					MaskUtil.unmask();
		    					msgShow('提示', '删除失败' , 'error');
		    				},
		    				async:false
		        		});
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
		$('#editWin').window('open');
	}
	
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
	
	//添加附件
	function addAtta(){
		$('#addAttaWin').window('open');
	}
	
	//计算
	function caculation(addDensity, addBase, addSingle, addAmount, addTotal){
		var reg = new RegExp("^[0-9]+(.[0-9]+)?$");
		var density = $('#' + addDensity).val();
		var base = $('#' + addBase).val();
		var amount = $('#' + addAmount).val();
		//param1、param2不等于空  可以计算param3
		if(reg.test(density) && reg.test(base)){
			var single = density * base;
			$('#' + addSingle).val(single.toFixed(3));
		}
		//param3、param4不等于空  可以计算 param5
		var single = $('#' + addSingle).val();
		if(reg.test(amount) && reg.test(single)){
			var total = single * amount;
			$('#' + addTotal).val(total.toFixed(3));
		}
	}
	
	//提交设计方案
	function submitDesign(data){
		MaskUtil.mask();
		$.ajax({
			url:"<%=request.getContextPath()%>/design/submitDesign?id=" + data.id,
			type:"post",
			dataType:"json",
			success:function(data, textStatus){
				MaskUtil.unmask();
				if(data.flag){
					msgShow('提示','提交成功','info');
					$('#designList').datagrid('reload');
				}else{
					msgShow('提示','提交失败','error');
				}
			},
			error:function(){
				MaskUtil.unmask();
				msgShow('提示', '提交失败' , 'error');
			},
			async:false
		});
	}
</script>
</head>
<body>
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
	<table id="designList">
	</table>
	
	<div id="editWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-edit">  
         <input type="hidden" id="designId">
    	  <table style="width: 100%;">
    	  	<tr style="line-height: 25px;">
    	  		<td style="width: 8%; text-align: right;">合同编号：</td>
    	  		<td style="width: 15%; text-align: left;" id="editOrderNo"></td>
    	  		
    	  		<td style="width: 8%; text-align: right;">产品名称：</td>
    	  		<td style="width: 15%; text-align: left;" id="editName"></td>
    	  		
    	  		<td style="width: 8%; text-align: right;">数量：</td>
    	  		<td style="width: 8%; text-align: left;" id="editQuantity"></td>
    	  		
    	  		<td style="width: 8%; text-align: right;">单位：</td>
    	  		<td style="width: 8%; text-align: left;" id="editUnit"></td>
    	  	</tr>
    	  	
    	  	<tr>
    	  		<td style="width: 8%; text-align: right;">规格型号：</td>
    	  		<td style="width: 15%; text-align: left;" id="editModel"></td>
    	  		
    	  		<td style="width: 8%; text-align: right;">技术参数：</td>
    	  		<td style="width: 15%; text-align: left;" id="editTechParam"></td>
    	  	</tr>
    	  </table>
    	  
    	<table id="editMaterialList"></table>
    	<div style="height: 10px;"></div>
    	<table id="editDrawingList"></table>  
    	
   		<table style="width: 100%;">
   	  		<tr>
   	  			<td style="text-align: center;">
   	  				<a id="submit" class="easyui-linkbutton" iconCls="icon-ok">提交</a>
   	  			</td>
   	  		</tr>
   		</table>
  	</div>
	
	<div id="viewWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-search">  
         <input type="hidden" id="designId">
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
  	
  	<div id="addMaterWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-add">
  		<h1 align="center" style="color:#15428B;">添加物料</h1>
       	<div align="center" style="margin:20px;">
       		<form action="#" method="post" id="addMaterForm">
       			<input type="hidden" name="designId" id="addDesignId"/>
           		<table width="400" border="0"  align="center" >
           			<tr>
               			<td width="140" style="text-align: right;">名称：</td>
               			<td>
               				<input name="name" class="easyui-validatebox" required="true" style="width: 200px;">
               			</td>
           			</tr>
           			<tr>
               			<td style="text-align: right;">规格：</td>
               			<td>
               				<input name="model" class="easyui-validatebox" style="width: 200px;">
               			</td>
           			</tr>
           			<tr>
               			<td style="text-align: right;">理论密度(Kg/单位)：</td>
               			<td>
               				<input id="addDensity" name="density" class="easyui-validatebox" 
               					required="true" validType="nums" style="width: 200px;"
               					onchange="caculation('addDensity', 'addBase', 'addSingle', 'addAmount', 'addTotal')">
               			</td>
           			</tr>
           			<tr>
               			<td style="text-align: right;">计算基数：</td>
               			<td>
               				<input id="addBase" name="caculationsBase" class="easyui-validatebox" 
               					required="true" 
               					validType="nums" style="width: 200px;"
               					onchange="caculation('addDensity', 'addBase', 'addSingle', 'addAmount', 'addTotal')">
               			</td>
           			</tr>
           			<tr>
               			<td style="text-align: right;">单位：</td>
               			<td>
               				<input name="unitName" class="easyui-validatebox" required="true" 
               					style="width: 200px;">
               			</td>
           			</tr>
           			<tr>
               			<td style="text-align: right;">单台物料质量(Kg)：</td>
               			<td>
               				<input readonly="readonly" id="addSingle" name="singleQuantity" 
               					class="easyui-validatebox" required="true" validType="nums" 
               					style="width: 200px;">
               			</td>
           			</tr>
           			<tr>
               			<td style="text-align: right;">数量：</td>
               			<td>
               				<input id="addAmount" name="amount" class="easyui-validatebox" required="true" 
               					validType="nums" style="width: 200px;"
               					onchange="caculation('addDensity', 'addBase', 'addSingle', 'addAmount', 'addTotal')">
               			</td>
           			</tr>
           			<tr>
               			<td style="text-align: right;">物料总质量(Kg)：</td>
               			<td>
               				<input readonly="readonly" id="addTotal" name="totalQuantity" 
               					class="easyui-validatebox" required="true" validType="nums" 
               					style="width: 200px;">
               			</td>
           			</tr>
           			<tr>
               			<td style="text-align: right;">备注：</td>
               			<td>
               				<input name="remark" style="width: 200px;">
               			</td>
           			</tr>
             				
           			<tr>
               			<td style="text-align: center;" colspan="2">
               				<a id="add-mater-save" class="easyui-linkbutton" iconCls="icon-save">保存</a>
               			</td>
           			</tr>
           		</table>
       		</form>
       	</div>
	</div>
	
	<div id="editMaterWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-edit">
  		<h1 align="center" style="color:#15428B;">添加物料</h1>
       	<div align="center" style="margin:20px;">
       		<form action="#" method="post" id="editMaterForm">
       			<input type="hidden" name="id"/>
           		<table width="400" border="0"  align="center" >
           			<tr>
               			<td width="140" style="text-align: right;">名称：</td>
               			<td>
               				<input name="name" class="easyui-validatebox" required="true" style="width: 200px;">
               			</td>
           			</tr>
           			<tr>
               			<td style="text-align: right;">规格：</td>
               			<td>
               				<input name="model" class="easyui-validatebox" style="width: 200px;">
               			</td>
           			</tr>
           			<tr>
               			<td style="text-align: right;">理论密度(Kg/单位)：</td>
               			<td>
               				<input id="editDensity" name="density" class="easyui-validatebox" 
               					required="true" validType="nums" style="width: 200px;"
               					onchange="caculation('editDensity', 'editBase', 'editSingle', 'editAmount', 'editTotal')">
               			</td>
           			</tr>
           			<tr>
               			<td style="text-align: right;">计算基数：</td>
               			<td>
               				<input id="editBase" name="caculationsBase" class="easyui-validatebox" 
               					required="true" 
               					validType="nums" style="width: 200px;"
               					onchange="caculation('editDensity', 'editBase', 'editSingle', 'editAmount', 'editTotal')">
               			</td>
           			</tr>
           			<tr>
               			<td style="text-align: right;">单位：</td>
               			<td>
               				<input name="unitName" class="easyui-validatebox" required="true" 
               					style="width: 200px;">
               			</td>
           			</tr>
           			<tr>
               			<td style="text-align: right;">单台物料质量(Kg)：</td>
               			<td>
               				<input readonly="readonly" id="editSingle" name="singleQuantity" 
               					class="easyui-validatebox" required="true" validType="nums" 
               					style="width: 200px;">
               			</td>
           			</tr>
           			<tr>
               			<td style="text-align: right;">数量：</td>
               			<td>
               				<input id="editAmount" name="amount" class="easyui-validatebox" required="true" 
               					validType="nums" style="width: 200px;"
               					onchange="caculation('editDensity', 'editBase', 'editSingle', 'editAmount', 'editTotal')">
               			</td>
           			</tr>
           			<tr>
               			<td style="text-align: right;">物料总质量(Kg)：</td>
               			<td>
               				<input readonly="readonly" id="editTotal" name="totalQuantity" 
               					class="easyui-validatebox" required="true" validType="nums" 
               					style="width: 200px;">
               			</td>
           			</tr>
           			<tr>
               			<td style="text-align: right;">备注：</td>
               			<td>
               				<input name="remark" style="width: 200px;">
               			</td>
           			</tr>
             				
           			<tr>
               			<td style="text-align: center;" colspan="2">
               				<a id="edit-mater-save" class="easyui-linkbutton" iconCls="icon-save">保存</a>
               			</td>
           			</tr>
           		</table>
       		</form>
       	</div>
	</div>
	
	<div id="addAttaWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-add">
        <div style="height: 40px;"></div>
        <form action="#" id="attaForm" method="post" enctype="multipart/form-data">
        	<input type="hidden" id="atta_designId" name="designId"/>
    		<table style="width: 100%;">
    			<tr style="line-height: 30px;">
    				<td style="width: 100%; text-align: center;">
    					<input id="attaFile" type="file" name="file" class="easyui-validatebox" required="true"/>
    				</td>
    			</tr>
    			<tr style="line-height: 30px;">
    				<td style="width: 100%; text-align: center;">
    					<a id="atta_upload" class="easyui-linkbutton" iconCls="icon-save">上传</a>
    				</td>
    			</tr>
    		</table>
    	</form>
    </div>
</body>
</html>