<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>收款单录入</title>
<link id="easyuiTheme" href="<%=request.getContextPath()%>/themes/metro/easyui.css" rel="stylesheet" type="text/css" />
<link href="<%=request.getContextPath()%>/themes/icon.css" rel="stylesheet" type="text/css" />
<script src="<%=request.getContextPath()%>/js/jquery.min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/jquery.easyui.min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/easyui-lang-zh_CN.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/outlook2.js" type="text/javascript"></script>
<style type="text/css">
	font{
		color: red;
	}
</style>
<script type="text/javascript">
	$(function(){
		
		$('.datebox').datebox({
			editable: false
		});
		
		$('#orderList').datagrid({
			url: '<%=request.getContextPath()%>/gather/showOrders',
			title:'订单列表',
			toolbar:[
				{iconCls : 'icon-search', text : '查看收款单', 
					handler: function(){
						var data = $('#orderList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要查看的数据' , 'warning');
					 		return;
					 	}
						
						viewGathering(data);
					}
				}
			],
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			pagination:true,
			columns:[[
				{field:'signerId',  width:20, align:'center',
					formatter:function(value, rowData, rowIndex){
						if(rowData.unTotal != 0){
							return '<div style="width:10px;height:10px;background-color:yellow"></div>';	
						}else if(rowData.unTotal == 0){
							return '<div style="width:10px;height:10px;background-color:blue"></div>';
						}
					}
				},
				{field:'orderNo',title:'订单号',width:80},
				{field:'orderName',title:'订单名称',width:80},
				{field:'clientName',title:'客户名称',width:80},
				{field:'signDate',title:'签订日期',width:80, align:'center'},
				{field:'signUser',title:'签单人',width:80},
				{field:'total',title:'总额(元)',width:80, align:'right', formatter:
					function(value, rowData, rowIndex){
						return fmoney(value,2);
				}},
				{field:'hadTotal',title:'已收款(元)',width:80,align:'right', formatter:
					function(value, rowData, rowIndex){
					return fmoney(value,2);
				}},
				{field:'unTotal',title:'未收款(元)',width:80, align:'right', formatter:
					function(value, rowData, rowIndex){
					return fmoney(value,2);
				}}
			]],
			onDblClickRow:function(rowIndex, rowData) {  
				viewGathering(); 
	        },
		});
		
		var p = $('#orderList').datagrid('getPager'); 
		p.pagination({  
	        pageSize : 10,// 每页显示的记录条数，默认为20  
	        pageList : [ 10, 20, 30 ],// 可以设置每页记录条数的列表  
	        beforePageText : '第',// 页数文本框前显示的汉字  
	        afterPageText : '页    共 {pages} 页',  
	        displayMsg : '当前显示 {from} - {to} 条记录   共 {total} 条记录'   
	    });
		
		$('#signerUser_search').combobox({
			valueField:'id',
			textField:'text',
			editable:false
		});
		
		$.ajax({
			url:'<%=request.getContextPath()%>/user/getUsersByRole?roleCode=YWY',
			type:'post',
			dataType:'json',
			success:function(data){
				data.unshift({"id":"", "text":"全部"});
				$('#signerUser_search').combobox('loadData', data);
			},
			async:true
		});
		
		$('#search-status').combobox({
			data:[{"id":0, "text":'全部'}, {"id":1, "text":'未结清'}, {"id":2, "text":'已结清'}],
			valueField:"id",
			textField:"text",
			editable:false
		});
		
		$('#search-status').combobox('select', 0);
		
		$('#search').on('click', function(){
			$('#search_signer').val($('#signerUser_search').combobox('getValue'));
			$('#search_signDateBegin').val($('#signDateBegin').datebox('getValue'));
			$('#search_signDateEnd').val($('#signDateEnd').datebox('getValue'));
			$('#search_payDateBegin').val($('#payDateBegin').datebox('getValue'));
			$('#search_payDateEnd').val($('#payDateEnd').datebox('getValue'));
			
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
			
			$('#orderList').datagrid('options').queryParams = queryParams;
			$('#orderList').datagrid('reload');
		});
		
		$('#addGatheringTotal').on('change', function(){
			if(parseFloat($(this).val()) > parseFloat($('#viewUnTotalHidden').val())){
				$(this).val($('#viewUnTotalHidden').val());
			}
		});
		
		$('#add-gatherUser').combobox({
			url:'<%=request.getContextPath()%>/user/getUsersByRole?roleCode=YWY',
			valueField:'id',
			textField:'text',
			editable:false,
			required:true
		});
		
		$('#edit-gatherUser').combobox({
			url:'<%=request.getContextPath()%>/user/getUsersByRole?roleCode=YWY',
			valueField:'id',
			textField:'text',
			editable:false,
			required:true
		});
		
		$('#addGatherForm').form({
			url:'<%=request.getContextPath()%>/gather/saveGather',
			onSubmit:function(){
				$('#add_gatherUser').val($('#add-gatherUser').combobox('getValue'));
				//$('#add_signerId').val($('#signerUser_add').combobox('getValue'));
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
					$('#addGatherWin').window('close');
					$('#viewWin').window('close');
					$('#addGatherForm').form('reset');
					$('#orderList').datagrid('reload');
					//$('#viewGatheringList').datagrid('reload');
				}else{
					msgShow('提示','保存失败','error');
				}
			}
		});
		
		$('#addGatherSave').on('click', function(){
			$('#addGatherForm').submit();
		});
		
		$('#editGatherForm').form({
			url:'<%=request.getContextPath()%>/gather/updateGather',
			onSubmit:function(){
				$('#edit_gatherUser').val($('#edit-gatherUser').combobox('getValue'));
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
					$('#editGatherWin').window('close');
					$('#viewWin').window('close');
					$('#editGatherForm').form('reset');
					$('#orderList').datagrid('reload');
				}else{
					msgShow('提示','保存失败','error');
				}
			}
		});
		
		$('#editGatherSave').on('click', function(){
			$('#editGatherForm').submit();
		});
		
		$('#attaForm').form({
			url:'<%=request.getContextPath()%>/gather/addAtta',
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
					$('#editGatherAttaList').datagrid('reload');
					$('#addAttaWin').window('close');
				}else{
					msgShow('提示','上传失败','error');
				}
			}
		});
		
		$('#atta_upload').on('click', function(){
			$('#attaForm').submit();
		});
		
		$('#addGatherWin').window({
			title: '新增收款单',
			width: 500,
			modal: true,
            shadow: true,
            closed: true,
            height: 550,
            top:0,
            left:300
		});
		
		$('#viewGatherWin').window({
			title: '查看收款单',
			width: 1000,
			modal: true,
            shadow: true,
            closed: true,
            height: 550,
            top:0,
            left:50
		});
		
		$('#editGatherWin').window({
			title: '编辑收款单',
			width: 1000,
			modal: true,
            shadow: true,
            closed: true,
            height: 550,
            top:0,
            left:50
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
		
		$('#viewWin').window({
            title: '查看所有收款单',
            width: 1000,
            modal: true,
            shadow: true,
            closed: true,
            height: 550,
            top:0,
            left:50
        });
	});
	
	//查看订单
	function viewGathering(data){
		
		$('#viewOrderId').val(data.orderId);
		
		$('#viewOrderNo').html(data.orderNo);
		$('#viewSignUser').html(data.signUser);
		$('#viewTotal').html(fmoney(data.total,2));
		$('#viewSignDate').html(data.signDate);
		$('#viewClientName').html(data.clientName);
		$('#viewHadTotal').html(fmoney(data.hadTotal,2));
		$('#viewUnTotal').html(fmoney(data.unTotal,2));
		$('#viewUnTotalHidden').val(data.unTotal);
		
		$('#viewGatheringList').datagrid({
			url: '<%=request.getContextPath()%>/gather/getGatherListByOrderId?orderId=' + data.orderId,
			title:'收款单清单',
			toolbar:[
				{iconCls : 'icon-search', text : '查看', 
					handler: function(){
						var data = $('#viewGatheringList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要查看的数据' , 'warning');
					 		return;
					 	}
						
						viewGather(data);
					}
				},
				{iconCls : 'icon-add', text : '新增', 
					handler: function(){
						addGather();
					}
				},
				{iconCls : 'icon-edit', text : '编辑', 
					handler: function(){
						var data = $('#viewGatheringList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要编辑的数据' , 'warning');
					 		return;
					 	}
						
						editGather(data);
					}
				},
				{iconCls : 'icon-ok', text : '提交', 
					handler: function(){
						var data = $('#viewGatheringList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要编辑的数据' , 'warning');
					 		return;
					 	}
						
						submitGather(data);
					}
				},
				{iconCls : 'icon-remove', text : '删除', 
					handler: function(){
						var data = $('#viewGatheringList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要删除的数据' , 'warning');
					 		return;
					 	}
						if(data.status==0||data.status==-5555){
							removeGather(data);	
						}else{
							msgShow('提示', '只能删除未提交或被退回的数据' , 'warning');
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
				{field:'id',  width:10, align:'center',
					formatter:function(value, rowData, rowIndex){
						if(rowData.status == 0 || rowData.status == -5555){
							return '<div style="width:10px;height:10px;background-color:red"></div>';	
						}else if(rowData.status == 10 || rowData.status == 20){
							return '<div style="width:10px;height:10px;background-color:yellow"></div>';
						}else if(rowData.status == 30){
							return '<div style="width:10px;height:10px;background-color:blue"></div>';
						}
					}
				},
				{field:'code',title:'收款单编号',width:80, align:'center'},
				{field:'orderNo',title:'订单号',width:80, align:'center'},
				{field:'total',title:'收款金额(元)',width:80, align:'right', formatter:
					function(value, rowData, rowIndex){
						return fmoney(value,2);
					}
				},
				{field:'realname',title:'收款人',width:80},
				{field:'gatherDate', title:'收款日期', width:80, align:'center'},
				{field:'remark',title:'备注',width:80},
				{field:'status',title:'状态',width:80,formatter:
					function(value, rowData, rowIndex){
						if(value==0){
							return "未提交";
						}else if(value==10){
							return "销售部审批中";
						}else if(value==20){
							return "财务部审批中";
						}else if(value==30){
							return "已生效";
						}else if(value==-5555){
							return "退回";
						}
					}
				}
			]]
		});
		
		var productPage = $('#viewGatheringList').datagrid('getPager'); 
		productPage.pagination({  
	        pageSize : 10,// 每页显示的记录条数，默认为20  
	        pageList : [10],// 可以设置每页记录条数的列表  
	        beforePageText : '第',// 页数文本框前显示的汉字  
	        afterPageText : '页    共 {pages} 页',  
	        displayMsg : '当前显示 {from} - {to} 条记录   共 {total} 条记录'   
	    });
		
		$('#viewWin').window('open'); 
	}
	
	//添加收款单
	function addGather(data){
		$('#addGatherOrderId').val($('#viewOrderId').val());
		
		$('#addGatherOrderNo').html($('#viewOrderNo').html());
		$('#addGatherTotal').html($('#viewTotal').html());
		$('#addGatherHadTotal').html($('#viewHadTotal').html());
		$('#addGatherUnTotal').html($('#viewUnTotal').html());
		
		$('#addGatherWin').window('open');
	}
	
	//查看收款单
	function viewGather(data){
		$('#viewGatherHadTotal').html(data.total);
		$('#viewGatherUser').html(data.realname);
		$('#viewGatherDate').html(data.gatherDate);
		$('#viewGatherRemark').html(data.remark);
		
		$('#viewGatherAttaList').datagrid({
			url: '<%=request.getContextPath()%>/gather/getGatherAttaList?id='+data.id,
			title:'附件清单',
			toolbar:[
				{iconCls : 'icon-ok', text : '下载附件', 
					handler: function(){
						var data = $('#viewGatherAttaList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要下载的数据' , 'warning');
					 		return;
					 	}
						
						downGatherAtta(data);
					}
				}
			],
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			pagination:false,
			columns:[[
				{field:'fileName',title:'附件名称',width:80}
			]]
		});
		
		$('#viewGatherAuditList').datagrid({
			url: '<%=request.getContextPath()%>/audit/getAuditList?id='+data.id+'&type=4',
			title:'审批记录',
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			pagination:false,
			columns:[[
				{field:'userDept',title:'部门',width:80},
				{field:'userName',title:'审批人',width:80},
				{field:'auditDate',title:'审批时间',width:80},
				{field:'comment',title:'审批意见',width:80},
				{field:'ioption',title:'操作',width:80, 
					formatter: function(value, rowData, rowIndex){
						return value==1?"通过":"退回";
					}
				},
			]]
		});
		
		$('#viewGatherWin').window('open');
	}
	
	//编辑收款单
	function editGather(data){
		
		$('#editGatherOrderNo').html($('#viewOrderNo').html());
		$('#editGatherTotal').html($('#viewTotal').html());
		$('#editGatherHadTotal').html($('#viewHadTotal').html());
		$('#editGatherUnTotal').html($('#viewUnTotal').html());
		
		$('#editGatherForm').form('load', data);
		$('#edit-gatherUser').combobox('select', data.gatherUser);
		
		$('#editGatherAttaList').datagrid({
			url: '<%=request.getContextPath()%>/gather/getGatherAttaList?id='+data.id,
			title:'附件清单',
			toolbar:[
				{iconCls : 'icon-add', text : '新增附件', 
					handler: function(){
						
						
						addGatherAtta(data);
					}
				},
				{iconCls : 'icon-ok', text : '下载附件', 
					handler: function(){
						var data = $('#editGatherAttaList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要查看的数据' , 'warning');
					 		return;
					 	}
						
						downGatherAtta(data);
					}
				},
				{iconCls : 'icon-remove', text : '删除附件', 
					handler: function(){
						var data = $('#editGatherAttaList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要查看的数据' , 'warning');
					 		return;
					 	}
						removeGatherAtta(data);
					}
				}
			],
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			pagination:false,
			columns:[[
				{field:'fileName',title:'附件名称',width:80}
			]]
		});
		$('#editGatherWin').window('open');
	}
	
	//提交请款单
	function submitGather(data){
		$.ajax({
			url:"<%=request.getContextPath()%>/gather/submitGather?id=" + data.id,
			type:"post",
			dataType:"json",
			success:function(data, textStatus){
				if(data.flag){
					msgShow('提示','提交成功','info');
					$('#viewGatheringList').datagrid('reload');
				}else{
					msgShow('提示','提交失败','error');
				}
			},
			error:function(){
				msgShow('提示', '提交失败' , 'error');
			},
			async:false
		});
	}
	
	//删除请款单
	function removeGather(data){
		$.ajax({
			url:"<%=request.getContextPath()%>/gather/deleteGather?id=" + data.id,
			type:"post",
			dataType:"json",
			success:function(data, textStatus){
				if(data.flag){
					msgShow('提示','删除成功','info');
					$('#viewGatheringList').datagrid('reload');
				}else{
					msgShow('提示','删除失败','error');
				}
			},
			error:function(){
				msgShow('提示', '删除失败' , 'error');
			},
			async:false
		});
	}
	
	//添加附件
	function addGatherAtta(data){
		$('#atta_gatherId').val(data.id);
		$('#addAttaWin').window('open');
	}
	
	//下载附件
	function downGatherAtta(data){
		window.open('<%=request.getContextPath()%>/gather/downloadGatherAtta?id='+data.id);
	}
	
	//删除附件
	function removeGatherAtta(data){
		$.ajax({
			url:"<%=request.getContextPath()%>/gather/deleteGatherAtta?id=" + data.id,
			type:"post",
			dataType:"json",
			success:function(data, textStatus){
				if(data.flag){
					msgShow('提示','删除成功','info');
					$('#editGatherAttaList').datagrid('reload');
				}else{
					msgShow('提示','删除失败','error');
				}
			},
			error:function(){
				msgShow('提示', '删除失败' , 'error');
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
				订单号：
			</td>
			<td style="text-align: left;">
				<input style="width: 75%; height: 17px;" class="queryParam" name="orderNo"/>
			</td>
			<td style="text-align: right;">
				订单名称：
			</td>
			<td style="text-align: left;">
				<input class="queryParam" name="orderName" style="width: 75%; height: 17px;"/>
			</td>
			<td style="text-align: right;">
				客户名称：
			</td>
			<td style="text-align: left;">
				<input class="queryParam" name="clientName" style="width: 75%; height: 17px;"/>
			</td>
			<td style="text-align: right;">
				签单人：
			</td>
			<td style="text-align: left;">
				<input id="signerUser_search" style="width: 150px; height: 22px;"/>
				<input type="hidden" class="queryParam" name="signUser" id="search_signer">
			</td>
		</tr>
		<tr>
			<td style="text-align: right;">
				签订日期：
			</td>
			<td style="text-align: left;">
				<input class="easyui-datebox" id="signDateBegin" style="width: 155%; height: 23px;"/>
				<input type="hidden" class="queryParam" id="search_signDateBegin" name="signDateBegin"/>
			</td>
			<td style="text-align: left;">
				至
			</td>
			<td style="text-align: left;">
				<input class="easyui-datebox" id="signDateEnd" style="width: 155%; height: 23px;"/>
				<input type="hidden" class="queryParam" id="search_signDateEnd" name="signDateEnd"/>
			</td>
			<td style="text-align: right;">
				交付日期：
			</td>
			<td style="text-align: left;">
				<input class="easyui-datebox" id="payDateBegin" style="width: 155%; height: 23px;"/>
				<input type="hidden" class="queryParam" id="search_payDateBegin" name="payDateBegin"/>
			</td>
			<td style="text-align: left;">
				至
			</td>
			<td style="text-align: left;">
				<input class="easyui-datebox" id="payDateEnd" style="width: 155%; height: 23px;"/>
				<input type="hidden" class="queryParam" id="search_payDateEnd" name="payDateEnd"/>
			</td>
		</tr>
		<tr>
			<td style="text-align: right;">
				总额(元)：
			</td>
			<td style="text-align: left;">
				<input class="queryParam" name="totalBegin" style="width: 75%; height: 17px;"/>
			</td>
			<td style="text-align: left;">
				至
			</td>
			<td style="text-align: left;">
				<input class="queryParam" name="totalEnd" style="width: 75%; height: 17px;"/>
			</td>
			<td style="text-align: right;">
				状态：
			</td>
			<td style="text-align: left;">
				<input id="search-status" style="width: 150px; height: 22px;"/>
			</td>
			<td style="text-align: center;" colspan="2">
				<a id="search" class="easyui-linkbutton" style="height: 25px;" iconCls="icon-search">搜索</a>
			</td>
		</tr>
	</table>
	<div style="height: 10px;"></div>
	<table id="orderList">
	</table>
	<div id="viewWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-search">
        <input type="hidden" id="viewOrderId">	
        <input type="hidden" id="viewUnTotalHidden">	  
		<table style="width: 100%;">
			<tr style="line-height: 25px;">
				<td style="width: 8%; text-align: right;">订单号：</td>
				<td style="width: 15%; text-align: left;" id="viewOrderNo"></td>
				
				<td style="width: 8%; text-align: right;">签单人：</td>
				<td style="width: 8%; text-align: left;" id="viewSignUser"></td>
				
				<td style="width: 8%;text-align: right;">客户名称：</td>
				<td style="width: 8%;text-align: left;" id="viewClientName"></td>
				
				<td style="width: 8%; text-align: right;">签订日期：</td>
				<td style="width: 8%; text-align: left;" id="viewSignDate"></td>
			</tr>
			<tr style="line-height: 25px;">
				<td style="text-align: right;">总金额(元)：</td>
				<td style="text-align: left;" id="viewTotal"></td>
				
				<td style="text-align: right;">已收款金额(元)：</td>
				<td style="text-align: left;" id="viewHadTotal"></td>
				
				<td style="text-align: right;">未收款金额(元)：</td>
				<td style="text-align: left;" id="viewUnTotal"></td>
				
				<td style="text-align: right;"></td>
				<td style="text-align: left;"></td>
			</tr>
		</table>
		
		<table id="viewGatheringList"></table>
  	</div>
  	
  	<div id="addGatherWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-add">
  		<h1 align="center" style="color:#15428B;">新增收款单</h1>
       	<div align="center" style="margin:20px;">
       		<form id="addGatherForm" action="#" method="post">
       			<input type="hidden" name="orderId" id="addGatherOrderId">
           		<table width="100%" border="0"  align="center" >
           			<tr>
               			<td style="width: 30%; text-align: right;">订单号：</td>
               			<td id="addGatherOrderNo">
               			</td>
           			</tr>
           			<tr>
               			<td style="width: 30%; text-align: right;">总额(元)：</td>
               			<td id="addGatherTotal">
               			</td>
           			</tr>
           			<tr>
               			<td style="width: 30%; text-align: right;">已收款(元)：</td>
               			<td id="addGatherHadTotal">
               			</td>
           			</tr>
           			<tr>
               			<td style="width: 30%; text-align: right;">未收款(元)：</td>
               			<td id="addGatherUnTotal">
               			</td>
           			</tr>
           			<tr>
               			<td style="width: 30%; text-align: right;">收款金额(元)：</td>
               			<td>
               				<input class="easyui-validatebox" name="total" required="true" 
               					style="width: 200px;" id="addGatheringTotal"
               					validType="nums">
               			</td>
           			</tr>
           			<tr>
               			<td style="width: 30%; text-align: right;">收款人：</td>
               			<td>
               				<input id="add-gatherUser" style="width: 200px;">
               				<input type="hidden" id="add_gatherUser" name="gatherUser">
               			</td>
           			</tr>
           			<tr>
               			<td style="width: 30%; text-align: right;">收款日期：</td>
               			<td>
               				<input class="datebox" name="gatherDate" required="true" style="width: 200px;">
               				
               			</td>
           			</tr>
           			<tr>
               			<td style="width: 30%; text-align: right;">备注：</td>
               			<td>
               				<textarea name="remark" style="width:200px; height:60px; margin:5px;"></textarea>
               			</td>
           			</tr>
             				
           			<tr>
               			<td style="text-align: center;" colspan="2">
               				<a class="easyui-linkbutton" iconCls="icon-save" id="addGatherSave">保存</a>
               			</td>
           			</tr>
           		</table>
       		</form>
       	</div>
	</div>
	
	<div id="editGatherWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-add">
  		<h1 align="center" style="color:#15428B;">编辑收款单</h1>
       	<div align="center" style="margin:20px;">
       		<form id="editGatherForm" action="#" method="post">
       			<input type="hidden" name="id" id="editGatherId"/>
           		<table width="100%" border="0"  align="center" >
           			<tr>
               			<td style="width: 10%; text-align: right;">订单号：</td>
               			<td id="editGatherOrderNo" style="width: 17%;"></td>
               			
               			<td style="width: 8%; text-align: right;">总额(元)：</td>
               			<td id="editGatherTotal" style="width: 17%;"></td>
               			
               			<td style="width: 8%; text-align: right;">已收款(元)：</td>
               			<td id="editGatherHadTotal" style="width: 17%;"></td>
               			
               			<td style="width: 8%; text-align: right;">未收款(元)：</td>
               			<td id="editGatherUnTotal" style="width: 17%;"></td>
           			</tr>
           			<tr>
               			<td style="width: 10%; text-align: right;">收款金额(元)：</td>
               			<td>
               				<input class="easyui-validatebox" name="total" required="true" 
               					style="width: 150px;" id="editGatheringTotal"
               					validType="nums">
               			</td>
               			
               			<td style="width: 8%; text-align: right;">收款人：</td>
               			<td>
               				<input id="edit-gatherUser" style="width: 150px;">
               				<input type="hidden" id="edit_gatherUser" name="gatherUser">
               			</td>
               			
               			<td style="width: 8%; text-align: right;">收款日期：</td>
               			<td>
               				<input class="datebox" name="gatherDate" required="true" style="width: 150px;">
               				
               			</td>
               			
               			<td></td><td></td>
           			</tr>
           			<tr>
               			<td style="width: 8%; text-align: right;">备注：</td>
               			<td colspan="7">
               				<textarea name="remark" style="width:400px; height:30px; margin:5px;"></textarea>
               			</td>
           			</tr>
           		</table>
           		
           		<div style="height: 10px;"></div>
           		<table id="editGatherAttaList"></table>
           		<table>
           			<tr>
               			<td style="text-align: center;" colspan="2">
               				<a class="easyui-linkbutton" iconCls="icon-save" id="editGatherSave">保存</a>
               			</td>
           			</tr>
           		</table>
       		</form>
       	</div>
	</div>
	
	<div id="viewGatherWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-add">
  		<h2 align="center" style="color:#15428B;">查看收款单</h2>
       	<div align="center" style="margin:20px;">
       		<form id="viewGatherForm" action="#" method="post">
           		<table width="100%" border="0"  align="center" >
           			<tr>
               			<td style="width: 10%; text-align: right;">收款金额(元)：</td>
               			<td id="viewGatherHadTotal"></td>
               			
               			<td style="width: 10%; text-align: right;">收款人：</td>
               			<td id="viewGatherUser"></td>
               			
               			<td style="width: 10%; text-align: right;">收款日期：</td>
               			<td id="viewGatherDate"></td>
           			</tr>
           			<tr>
               			<td style="width: 10%; text-align: right;">备注：</td>
               			<td id="viewGatherRemark"></td>
           			</tr>
           		</table>
           		<div style="height: 10px;"></div>
           		<table id="viewGatherAttaList"></table>
           		<div style="height: 10px;"></div>
           		<table id="viewGatherAuditList"></table>
       		</form>
       	</div>
	</div>
	
	<div id="addAttaWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-add">
        <div style="height: 40px;"></div>
    	
    	<form action="#" id="attaForm" method="post" enctype="multipart/form-data">
        	<input type="hidden" id="atta_gatherId" name="gatherId"/>
    		<table style="width: 100%;">
    			<tr style="line-height: 30px;">
    				<td style="width: 100%; text-align: center;">
    					<input type="file" name="file" class="easyui-validatebox" required="true"/>
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