<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>付款单录入</title>
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
		
		$('#contractList').datagrid({
			url: '<%=request.getContextPath()%>/payment/getContractList',
			title:'采购订单列表',
			toolbar:[
				{iconCls : 'icon-search', 
				 text : '查看付款申请单', 
				 handler: 
					function(){
					 	var data = $('#contractList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要查看的数据' , 'warning');
					 		return;
					 	}
						viewPaymentList(data);
				 	}
				}
			],
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			pagination:true,
			columns:[[
				{field:'id',  width:20, align:'center',
					formatter:function(value, rowData, rowIndex){
						if(rowData.unPay != 0){
							return '<div style="width:10px;height:10px;background-color:yellow"></div>';	
						}else if(rowData.unPay == 0){
							return '<div style="width:10px;height:10px;background-color:blue"></div>';
						}
					}
				},      
				{field:'code',title:'采购订单号',width:80},
				{field:'name',title:'订单名称',width:80},
				{field:'supplier',title:'供应商',width:80},
				{field:'signDateStr',title:'签订日期',width:80},
				{field:'signUserName',title:'签单人',width:80},
				{field:'sum',title:'总额(元)',width:80, align:'right',
					formatter:function(value, rowData, rowIndex){
						return fmoney(value);		
					}
				},
				{field:'hadPay',title:'已生效(元)',width:80,align:'right',
					formatter:function(value, rowData, rowIndex){
						return fmoney(value);		
					}
				},
				{field:'unPay',title:'未付款(元)',width:80, align:'right',
					formatter:function(value, rowData, rowIndex){
						return fmoney(value);	
					}
				},
				{field:'hadBill',title:'已开票金额(元)',width:80,align:'right',
					formatter:function(value, rowData, rowIndex){
						return fmoney(value);		
					}
				},
				{field:'unBill',title:'未开票金额(元)',width:80, align:'right',
					formatter:function(value, rowData, rowIndex){
						return fmoney(value);	
					}
				}
			]]
		});
		
		var p = $('#contractList').datagrid('getPager'); 
		p.pagination({  
	        pageSize : 10,// 每页显示的记录条数，默认为20  
	        pageList : [ 10, 20, 30 ],// 可以设置每页记录条数的列表  
	        beforePageText : '第',// 页数文本框前显示的汉字  
	        afterPageText : '页    共 {pages} 页',  
	        displayMsg : '当前显示 {from} - {to} 条记录   共 {total} 条记录'   
	    });
		
		$('#addPaymentForm').form({
			url:'<%=request.getContextPath()%>/payment/savePayment',
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
					$('#addPaymentWin').window('close');
					$('#viewWin').window('close');
					$('#addPaymentForm').form('reset');
					$('#contractList').datagrid('reload');
				}else{
					msgShow('提示','保存失败','error');
				}
			}
		});
		
		$('#addPaymentSave').on('click', function(){
			$('#addPaymentForm').submit();
		});
		
		$('#editPaymentForm').form({
			url:'<%=request.getContextPath()%>/payment/updatePayment',
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
					$('#editPaymentWin').window('close');
					$('#viewWin').window('close');
					$('#editPaymentForm').form('reset');
					$('#contractList').datagrid('reload');
				}else{
					msgShow('提示','保存失败','error');
				}
			}
		});
		
		$('#editPaymentSave').on('click', function(){
			$('#editPaymentForm').submit();
		});
		
		$('#attaForm').form({
			url:'<%=request.getContextPath()%>/payment/addAtta',
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
					$('#editPaymentAttaList').datagrid('reload');
					$('#addAttaWin').window('close');
				}else{
					msgShow('提示','上传失败','error');
				}
			}
		});
		
		$('#atta_upload').on('click', function(){
			$('#attaForm').submit();
		});
		
		$('#viewWin').window({
            title: '查看付款申请单',
            width: 1000,
            modal: true,
            shadow: true,
            closed: true,
            height: 550,
            top:0,
            left:50
        });
		
		$('#viewPaymentWin').window({
			title: '查看付款申请单',
			width: 1000,
			modal: true,
            shadow: true,
            closed: true,
            height: 550,
            top:0,
            left:50
		});
		
		$('#addPaymentWin').window({
			title: '新增付款申请单',
			width: 500,
			modal: true,
            shadow: true,
            closed: true,
            height: 550,
            top:0,
            left:300
		});
		
		$('#editPaymentWin').window({
			title: '编辑付款申请单',
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
	});
	
	//查看订单
	function viewPaymentList(data){
		$('#viewContractId').val(data.id);
		$('#viewContractNo').html(data.code);
		$('#viewSignUser').html(data.signUserName);
		$('#viewSupplier').html(data.supplier);
		$('#viewSignDate').html(data.signDateStr);
		$('#viewTotal').html(fmoney(data.sum));
		$('#viewHadPay').html(fmoney(data.hadPay));
		$('#viewUnPay').html(fmoney(data.unPay));
		$('#viewHadBill').html(fmoney(data.hadBill));
		$('#viewUnBill').html(fmoney(data.unBill));
		
		$('#viewPaymentList').datagrid({
			url: '<%=request.getContextPath()%>/payment/getPaymentList?contractId=' + data.id,
			title:'付款申请单清单',
			toolbar:[
				{iconCls : 'icon-search', text : '查看', 
					handler: function(){
						var data1 = $('#viewPaymentList').datagrid('getSelected');
						if(data1==null){
					 		msgShow('提示', '请选中需要查看的数据' , 'warning');
					 		return;
					 	}
						
						viewPayment(data1);
					}
				},
				{iconCls : 'icon-print', text : '导出', 
					handler: function(){
						var data1 = $('#viewPaymentList').datagrid('getSelected');
						if(data1==null){
					 		msgShow('提示', '请选中需要导出的数据' , 'warning');
					 		return;
					 	}
						
						printPayment(data1);
					}
				},
				{iconCls : 'icon-add', text : '新增', 
					handler: function(){
						addPayment(data);
					}
				},
				{iconCls : 'icon-edit', text : '编辑', 
					handler: function(){
						var data1 = $('#viewPaymentList').datagrid('getSelected');
						if(data1==null){
					 		msgShow('提示', '请选中需要编辑的数据' , 'warning');
					 		return;
					 	}
						
						if(data1.status==0 || data1.status==-5555){
							editPayment(data1);	
						}else{
							msgShow('提示', '只能编辑未提交或退回状态的付款申请单', 'warning');
						}
					}
				},
				{iconCls : 'icon-ok', text : '提交', 
					handler: function(){
						var data1 = $('#viewPaymentList').datagrid('getSelected');
						if(data1==null){
					 		msgShow('提示', '请选中需要编辑的数据' , 'warning');
					 		return;
					 	}
						if(data1.status==0||data1.status==-5555){
							submitPayment(data1);	
						}else{
							msgShow('提示', '只能删除未提交或被退回的数据' , 'warning');
						}
					}
				},
				{iconCls : 'icon-remove', text : '删除', 
					handler: function(){
						var data1 = $('#viewPaymentList').datagrid('getSelected');
						if(data1==null){
					 		msgShow('提示', '请选中需要删除的数据' , 'warning');
					 		return;
					 	}
						if(data1.status==0||data1.status==-5555){
							removePayment(data1);	
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
				{field:'code',title:'付款申请单编号',width:80},
				{field:'accountName',title:'收款账户名',width:80},
				{field:'accountNo',title:'收款账号',width:80},
				{field:'total',title:'申请金额(元)',width:80,align:'right',
					formatter:function(value, rowData, rowIndex){
						return fmoney(value);	
					}
				},
				{field:'bill',title:'开票金额(元)',width:80,align:'right',
					formatter:function(value, rowData, rowIndex){
						return fmoney(value);	
					}
				},
				{field:'applyUserName',title:'申请人',width:80},
				{field:'applyDateStr',title:'申请日期',width:80,align:'center'},
				{field:'status',title:'状态',width:80,
					formatter:function(value, rowData, rowIndex){
						if(value==0){
							return '未提交';
						}else if(value==-5555){
							return '退回';
						}else if(value==10){
							return '采购部领导审批中';
						}else if(value==20){
							return '财务部领导审批中';
						}else if(value==30){
							return '已生效';
						}
					}
				}
			]]
		});
		
		$('#viewWin').window('open'); 
	}
	
	//查看付款申请单
	function viewPayment(data){
		
		$('#viewPaymentTotal').html(fmoney(data.total));
		$('#viewPaymentApplyUser').html(data.applyUserName);
		$('#viewPaymentApplyDate').html(data.applyDateStr);
		$('#viewPaymentRemark').html(data.remark);
		$('#viewBill').html(fmoney(data.bill));
		
		$('#viewPaymentAttaList').datagrid({
			url: '<%=request.getContextPath()%>/payment/getPaymentAttaList?paymentId='+data.id,
			title:'附件清单',
			toolbar:[
				{iconCls : 'icon-ok', text : '下载附件', 
					handler: function(){
						var data = $('#viewPaymentAttaList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要下载的数据' , 'warning');
					 		return;
					 	}
						
						downPaymentAtta(data);
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
		
		$('#viewPaymentAuditList').datagrid({
			url: '<%=request.getContextPath()%>/audit/getAuditList?id='+data.id+'&type=8',
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
		
		$('#viewPaymentWin').window('open');
	}
	
	//下载附件
	function downPaymentAtta(data){
		window.location = '<%=request.getContextPath()%>/payment/downloadPaymentAtta?id='+data.id;
	}
	
	//添加付款申请单
	function addPayment(){
		$('#addPaymentContractId').val($('#viewContractId').val());
		
		$('#addPaymentContractCode').html($('#viewContractNo').html());
		$('#addPaymentContractTotal').html($('#viewTotal').html());
		$('#addPaymentHadTotal').html($('#viewHadPay').html());
		$('#addPaymentUnTotal').html($('#viewUnPay').html());
		$('#addPaymentUnBill').html($('#viewUnBill').html());
		
		$('#addPaymentWin').window('open');
	}
	
	//编辑收款单
	function editPayment(data){
		
		$('#editPaymentContractNo').html($('#viewContractNo').html());
		$('#editPaymentContractTotal').html($('#viewTotal').html());
		$('#editPaymentHadTotal').html($('#viewHadPay').html());
		$('#editPaymentUnTotal').html($('#viewUnPay').html());
		$('#editPaymentUnBill').html($('#viewUnBill').html());
		
		$('#editPaymentForm').form('load', data);
		
		$('#editPaymentAttaList').datagrid({
			url: '<%=request.getContextPath()%>/payment/getPaymentAttaList?id='+data.id,
			title:'附件清单',
			toolbar:[
				{iconCls : 'icon-add', text : '新增附件', 
					handler: function(){
						addPaymentAtta(data);
					}
				},
				{iconCls : 'icon-ok', text : '下载附件', 
					handler: function(){
						var data = $('#editPaymentAttaList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要查看的数据' , 'warning');
					 		return;
					 	}
						
						downPaymentAtta(data);
					}
				},
				{iconCls : 'icon-remove', text : '删除附件', 
					handler: function(){
						var data = $('#editPaymentAttaList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要删除的数据' , 'warning');
					 		return;
					 	}
						
						removePaymentAtta(data);
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
		$('#editPaymentWin').window('open');
	}
	
	//添加附件
	function addPaymentAtta(data){
		$('#atta_paymentId').val(data.id);
		$('#addAttaWin').window('open');
	}
	
	//删除付款申请单附件数据
	function removePaymentAtta(data){
		$.ajax({
			url:"<%=request.getContextPath()%>/payment/deletePaymentAtta?id=" + data.id,
			type:"post",
			dataType:"json",
			success:function(data, textStatus){
				if(data.flag){
					msgShow('提示','删除成功','info');
					$('#editPaymentAttaList').datagrid('reload');
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
	
	//删除付款申请单
	function removePayment(data){
		$.ajax({
			url:"<%=request.getContextPath()%>/payment/deletePayment?id=" + data.id,
			type:"post",
			dataType:"json",
			success:function(data, textStatus){
				if(data.flag){
					msgShow('提示','删除成功','info');
					$('#viewPaymentList').datagrid('reload');
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
	
	//提交付款申请单
	function submitPayment(data){
		$.ajax({
			url:"<%=request.getContextPath()%>/payment/submitPayment?id=" + data.id,
			type:"post",
			dataType:"json",
			success:function(data, textStatus){
				if(data.flag){
					msgShow('提示','提交成功','info');
					$('#viewPaymentList').datagrid('reload');
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
	
	//导出付款申请单
	function printPayment(data){
		window.location = "<%=request.getContextPath()%>/payment/printPayment?id=" + data.id;
	}
</script>
</head>
<body>
	<table style="width:100%;height:auto;border: 1px solid #ccc; font-size: 12px;color: #888;padding: 5px;">
		<tr style="line-height: 30px;">
			<td style="text-align: right;">
				采购订单号：
			</td>
			<td style="text-align: left;">
				<input style="width: 75%; height: 17px;"/>
			</td>
			<td style="text-align: right;">
				订单名称：
			</td>
			<td style="text-align: left;">
				<input style="width: 75%; height: 17px;"/>
			</td>
			<td style="text-align: right;">
				客户名称：
			</td>
			<td style="text-align: left;">
				<input style="width: 75%; height: 17px;"/>
			</td>
			<td style="text-align: right;">
				签单人：
			</td>
			<td style="text-align: left;">
				<input style="width: 75%; height: 17px;"/>
			</td>
		</tr>
		<tr style="line-height: 30px;">
			<td style="text-align: right;">
				签订日期：
			</td>
			<td style="text-align: left;">
				<input class="easyui-datebox" style="width: 155%; height: 23px;"/>
			</td>
			<td style="text-align: left;">
				至
			</td>
			<td style="text-align: left;">
				<input class="easyui-datebox" style="width: 155%; height: 23px;"/>
			</td>
			<td style="text-align: right;">
				交付日期：
			</td>
			<td style="text-align: left;">
				<input class="easyui-datebox" style="width: 155%; height: 23px;"/>
			</td>
			<td style="text-align: left;">
				至
			</td>
			<td style="text-align: left;">
				<input class="easyui-datebox" style="width: 155%; height: 23px;"/>
			</td>
		</tr>
		<tr style="line-height: 30px;">
			<td style="text-align: right;">
				总额：
			</td>
			<td style="text-align: left;">
				<input style="width: 75%; height: 17px;"/>
			</td>
			<td style="text-align: left;">
				至
			</td>
			<td style="text-align: left;">
				<input style="width: 75%; height: 17px;"/>
			</td>
			<td style="text-align: right;">
				状态：
			</td>
			<td style="text-align: left;">
				<input style="width: 75%; height: 17px;"/>
			</td>
			<td style="text-align: center;" colspan="2">
				<a id="search" class="easyui-linkbutton" style="height: 25px;" iconCls="icon-search">搜索</a>
			</td>
		</tr>
	</table>
	<div style="height: 10px;"></div>
	<table id="contractList"></table>
	
	<div id="viewWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-search">
        <input type="hidden" id="viewContractId">			  
		<table style="width: 100%;">
			<tr style="line-height: 25px;">
				<td style="width: 8%; text-align: right;">采购订单号：</td>
				<td style="width: 15%; text-align: left;" id="viewContractNo"></td>
				
				<td style="width: 8%; text-align: right;">签单人：</td>
				<td style="width: 8%; text-align: left;" id="viewSignUser"></td>
				
				<td style="width: 8%;text-align: right;">供应商名称：</td>
				<td style="width: 8%;text-align: left;" id="viewSupplier"></td>
				
				<td style="width: 8%; text-align: right;">签订日期：</td>
				<td style="width: 8%; text-align: left;" id="viewSignDate"></td>
			</tr>
			<tr style="line-height: 25px;">
				<td style="text-align: right;">总金额(元)：</td>
				<td style="text-align: left;" id="viewTotal"></td>
				
				<td style="text-align: right;">已生效金额(元)：</td>
				<td style="text-align: left;" id="viewHadPay"></td>
				
				<td style="text-align: right;">未付款金额(元)：</td>
				<td style="text-align: left;" id="viewUnPay"></td>
				
				<td style="text-align: right;"></td>
				<td style="text-align: left;"></td>
			</tr>
			
			<tr style="line-height: 25px;">
				<td style="text-align: right;">已开票金额(元)：</td>
				<td style="text-align: left;" id="viewHadBill"></td>
				
				<td style="text-align: right;">未开票金额(元)：</td>
				<td style="text-align: left;" id="viewUnBill"></td>
				
				<td style="text-align: right;"></td>
				<td style="text-align: left;"></td>
				
				<td style="text-align: right;"></td>
				<td style="text-align: left;"></td>
			</tr>
		</table>
		
		<table id="viewPaymentList"></table>
  	</div>
  	
  	<div id="viewPaymentWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-add">
  		<h2 align="center" style="color:#15428B;">查看付款申请单</h2>
       	<div align="center" style="margin:20px;">
       		<form id="viewGatherForm" action="#" method="post">
           		<table width="100%" border="0"  align="center" >
           			<tr>
               			<td style="width: 10%; text-align: right;">申请金额(元)：</td>
               			<td id="viewPaymentTotal"></td>
               			
               			<td style="width: 10%; text-align: right;">申请人：</td>
               			<td id="viewPaymentApplyUser"></td>
               			
               			<td style="width: 10%; text-align: right;">申请日期：</td>
               			<td id="viewPaymentApplyDate"></td>
           			</tr>
           			<tr>
               			<td style="width: 10%; text-align: right;">开票金额(元)：</td>
               			<td id="viewBill"></td>
               			
               			<td style="width: 10%; text-align: right;"></td>
               			<td></td>
               			
               			<td style="width: 10%; text-align: right;"></td>
               			<td></td>
           			</tr>
           			<tr>
               			<td style="width: 10%; text-align: right;">备注：</td>
               			<td id="viewPaymentRemark"></td>
           			</tr>
           		</table>
           		<div style="height: 10px;"></div>
           		<table id="viewPaymentAttaList"></table>
           		<div style="height: 10px;"></div>
           		<table id="viewPaymentAuditList"></table>
       		</form>
       	</div>
	</div>
	
	<div id="addPaymentWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-add">
  		<h1 align="center" style="color:#15428B;">新增付款申请单</h1>
       	<div align="center" style="margin:20px;">
       		<form id="addPaymentForm" action="#" method="post">
       			<input type="hidden" name="contractId" id="addPaymentContractId">
           		<table width="100%" border="0"  align="center" >
           			<tr>
               			<td style="width: 30%; text-align: right;">采购订单号：</td>
               			<td id="addPaymentContractCode">
               			</td>
           			</tr>
           			<tr>
               			<td style="width: 30%; text-align: right;">总额(元)：</td>
               			<td id="addPaymentContractTotal">
               			</td>
           			</tr>
           			<tr>
               			<td style="width: 30%; text-align: right;">已生效(元)：</td>
               			<td id="addPaymentHadTotal">
               			</td>
           			</tr>
           			<tr>
               			<td style="width: 30%; text-align: right;">未付款(元)：</td>
               			<td id="addPaymentUnTotal">
               			</td>
           			</tr>
           			<tr>
               			<td style="width: 30%; text-align: right;">未开票金额(元)：</td>
               			<td id="addPaymentUnBill">
               			</td>
           			</tr>
           			<tr>
               			<td style="width: 30%; text-align: right;">申请金额(元)：</td>
               			<td>
               				<input class="easyui-validatebox" name="total" required="true" 
               					style="width: 200px;" id="addPaymentTotal"
               					validType="nums">
               			</td>
           			</tr>
           			<tr>
               			<td style="width: 30%; text-align: right;">开票金额(元)：</td>
               			<td>
               				<input class="easyui-validatebox" name="bill" required="true" 
               					style="width: 200px;" id="addPaymentBill"
               					validType="nums">
               			</td>
           			</tr>
           			<tr>
               			<td style="width: 30%; text-align: right;">申请日期：</td>
               			<td>
               				<input class="datebox" name="applyDateStr" required="true" style="width: 200px;">
               				
               			</td>
           			</tr>
           			<tr>
               			<td style="width: 30%; text-align: right;">申请理由：</td>
               			<td>
               				<input class="easyui-validatebox" name="applyReason" required="true" style="width: 200px;">
               				
               			</td>
           			</tr>
           			<tr>
               			<td style="width: 30%; text-align: right;">收款账户名：</td>
               			<td>
               				<input class="easyui-validatebox" name="accountName" required="true" style="width: 200px;">
               				
               			</td>
           			</tr>
           			<tr>
               			<td style="width: 30%; text-align: right;">收款账户：</td>
               			<td>
               				<input class="easyui-validatebox" name="accountNo" required="true" style="width: 200px;">
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
               				<a class="easyui-linkbutton" iconCls="icon-save" id="addPaymentSave">保存</a>
               			</td>
           			</tr>
           		</table>
       		</form>
       	</div>
	</div>
	
	<div id="editPaymentWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-add">
  		<h1 align="center" style="color:#15428B;">编辑付款申请单</h1>
       	<div align="center" style="margin:20px;">
       		<form id="editPaymentForm" action="#" method="post">
       			<input type="hidden" name="id" id="editPaymentId"/>
           		<table width="100%" border="0"  align="center" >
           			<tr>
               			<td style="width: 12%; text-align: right;">采购订单号：</td>
               			<td id="editPaymentContractNo" style="width: 17%;"></td>
               			
               			<td style="width: 8%; text-align: right;">总额(元)：</td>
               			<td id="editPaymentContractTotal" style="width: 17%;"></td>
               			
               			<td style="width: 10%; text-align: right;">已生效(元)：</td>
               			<td id="editPaymentHadTotal" style="width: 17%;"></td>
               			
               			<td style="width: 10%; text-align: right;">未付款(元)：</td>
               			<td id="editPaymentUnTotal" style="width: 17%;"></td>
           			</tr>
           			<tr>
               			<td style="width: 12%; text-align: right;">申请金额(元)：</td>
               			<td>
               				<input class="easyui-validatebox" name="total" required="true" 
               					style="width: 150px;" id="editPaymentTotal"
               					validType="nums">
               			</td>
               			
               			<td style="width: 8%; text-align: right;">收款账户名：</td>
               			<td>
               				<input class="easyui-validatebox" name="accountName" required="true" style="width: 150px;">
               			</td>
               			
               			<td style="width: 8%; text-align: right;">收款账户：</td>
               			<td>
               				<input class="easyui-validatebox" name="accountNo" required="true" style="width: 150px;">
               			</td>
               			
               			<td>申请日期：</td>
               			<td>
               				<input class="datebox" id="editPaymentApplyDate" name="applyDateStr" required="true" style="width: 150px;">
               			<td>
               			
               			</td>
           			</tr>
           			<tr>
               			<td style="width: 12%; text-align: right;">开票金额(元)：</td>
               			<td>
               				<input class="easyui-validatebox" name="bill" required="true" 
               					style="width: 150px;" id="editPaymentBill"
               					validType="nums">
               			</td>
               			
               			<td style="width: 2%; text-align: right;">未开票金额(元)：</td>
               			<td id="editPaymentUnBill">
               				
               			</td>
               			
               			<td style="width: 8%; text-align: right;">收款账户：</td>
               			<td>
               				<input class="easyui-validatebox" name="accountNo" required="true" style="width: 150px;">
               			</td>
               			
               			<td>申请日期：</td>
               			<td>
               				<input class="datebox" id="editPaymentApplyDate" name="applyDateStr" required="true" style="width: 150px;">
               			<td>
               			
               			</td>
           			</tr>
           			<tr>
               			<td style="width: 8%; text-align: right;">申请理由：</td>
               			<td colspan="7">
               				<input class="easyui-validatebox" name="applyReason" required="true" style="width: 200px;">
               				
               			</td>
           			</tr>
           			<tr>
               			<td style="width: 8%; text-align: right;">备注：</td>
               			<td colspan="7">
               				<textarea name="remark" style="width:400px; height:30px; margin:5px;"></textarea>
               			</td>
           			</tr>
           		</table>
           		
           		<div style="height: 10px;"></div>
           		<table id="editPaymentAttaList"></table>
           		<table>
           			<tr>
               			<td style="text-align: center;" colspan="2">
               				<a class="easyui-linkbutton" iconCls="icon-save" id="editPaymentSave">保存</a>
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
        	<input type="hidden" id="atta_paymentId" name="paymentId"/>
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