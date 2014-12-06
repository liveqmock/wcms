<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>付款申请单审批</title>
<link id="easyuiTheme" href="<%=request.getContextPath()%>/themes/metro/easyui.css" rel="stylesheet" type="text/css" />
<link href="<%=request.getContextPath()%>/themes/icon.css" rel="stylesheet" type="text/css" />
<script src="<%=request.getContextPath()%>/js/jquery.min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/jquery.easyui.min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/easyui-lang-zh_CN.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/outlook2.js" type="text/javascript"></script>

<script type="text/javascript">
	$(function(){
		//$(".datebox :text").attr("readonly","readonly");
		var seeStatus = $('#seeStatus').val();
		
		$('.datebox').datebox({
			editable:false
		});
		
		$('#paymentList').datagrid({
			url: '<%=request.getContextPath()%>/payment/getAuditPaymentList?seeStatus=' + seeStatus,
			title:'付款申请单列表',
			toolbar:[
				{iconCls : 'icon-search', text : '查看', 
					handler: function(){
						var data = $('#paymentList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要查看的数据' , 'warning');
					 		return;
					 	}
						
						viewPayment(data);
					}
				},
				{iconCls : 'icon-print', text : '导出', 
					handler: function(){
						var data1 = $('#paymentList').datagrid('getSelected');
						if(data1==null){
					 		msgShow('提示', '请选中需要导出的数据' , 'warning');
					 		return;
					 	}
						
						printPayment(data1);
					}
				},
				{iconCls : 'icon-search', text : '审批', 
					handler: function(){
						var data = $('#paymentList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要审批的数据' , 'warning');
					 		return;
					 	}
						
						if(data.status == seeStatus){
							auditPayment(data);	
						}else{
							msgShow('提示', '只能审批未审批的设计方案' , 'warning');
						}
					}
				},
				{iconCls : 'icon-ok', text : '通过', 
					handler: function(){
						var data = $('#paymentList').datagrid('getSelected');
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
				{field:'id',width:10, align:'center',
					formatter:function(value, rowData, rowIndex){
						if(rowData.status == seeStatus){
							return '<div style="width:10px;height:10px;background-color:yellow"></div>';	
						}else if(rowData.status > seeStatus){
							return '<div style="width:10px;height:10px;background-color:blue"></div>';
						}
					}
				},
				{field:'contractCode',title:'采购订单号',width:80},
				{field:'code',title:'付款申请单编号',width:80},
				{field:'total',title:'申请金额(元)',width:80, align:'right', 
					formatter:function(value, rowData, rowIndex){
						return fmoney(value);
					}	
				},
				{field:'bill',title:'开票金额(元)',width:80, align:'right', 
					formatter:function(value, rowData, rowIndex){
						return fmoney(value);
					}	
				},
				{field:'applyDateStr',title:'申请日期',width:80, align:'center'},
				{field:'applyUserName',title:'申请人',width:80},
				{field:'status',title:'状态',width:80, align:'center',
					formatter:function(value, rowData, rowIndex){
						if(value == seeStatus){
							return '未审批';
						}else if(value > seeStatus){
							return '已审批';
						}
					}
				}
			]],
			onDblClickRow:function(rowIndex, rowData) {  
				viewGathering(); 
	        },
		});
		
		var p = $('#paymentList').datagrid('getPager'); 
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
			url:'<%=request.getContextPath()%>/user/getUsersByRole?roleCode=CGY',
			type:'post',
			dataType:'json',
			success:function(data){
				data.unshift({"id":"", "text":"全部"});
				$('#signerUser_search').combobox('loadData', data);
			},
			async:true
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
				queryParams.auditStatus = status;	
			}
			
			$('#paymentList').datagrid('options').queryParams = queryParams;
			$('#paymentList').datagrid('reload');
		});
		
		$('#audit-pass').on('click', function(){
			var data = {"id":$('#auditPaymentId').val()};
			if(!strIsNull($('#auditComment').val())){
				data.comment = $('#auditComment').val();
			}else{
				data.comment = "";
			}
			submitAudit(data, 1);
			$('#auditWin').window('close');
		});
		
		$('#audit-cancel').on('click', function(){
			var data = {"id":$('#auditPaymentId').val()};
			
			if(strIsNull($('#auditComment').val())){
				msgShow('提示', '退回必须填写原因' , 'warning');
				return;
			}
			data.comment = $('#auditComment').val();
			submitAudit(data, 0);
			$('#auditWin').window('close');
		});
		
		$('#auditForm').form({
			url:'<%=request.getContextPath()%>/payment/submitAudit',
			onSubmit:function(){
				
			},
			success:function(data){
				var data = eval('(' + data + ')');
				MaskUtil.unmask();
				if(data.flag){
					$('#paymentList').datagrid('reload');
					$(this).form('reset');
					msgShow('提示', '提交成功' , 'info');
				}else{
					msgShow('提示', '提交失败' , 'error');
				}
			}
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
	});
	
	//审批收款单
	function auditPayment(data){
		$('#auditPaymentId').val(data.id);
		
		var array = new Array(1);
		array[0] = data;
		$('#viewPaymentList').datagrid({
			data: array,
			title:'本次付款申请单',
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			pagination:false,
			columns:[[
				{field:'code',title:'付款申请单编号',width:80, align:'center'},
				{field:'contractCode',title:'采购订单号',width:80, align:'center'},
				{field:'total',title:'申请金额(元)',width:80, align:'right',
					formatter:function(value, rowData, rowIndex){
						return fmoney(value);
					}	
				},
				{field:'bill',title:'开票金额(元)',width:80, align:'right',
					formatter:function(value, rowData, rowIndex){
						return fmoney(value);
					}	
				},
				{field:'unBill',title:'订单未开票总额(元)',width:80, align:'right',
					formatter:function(value, rowData, rowIndex){
						return fmoney(value);
					}	
				},
				{field:'contractSum',title:'采购订单总额(元)',width:80, align:'right',
					formatter:function(value, rowData, rowIndex){
						return fmoney(value);
					}	
				},
				{field:'applyDateStr',title:'申请日期',width:80, align:'center'},
				{field:'applyUserName',title:'申请人',width:80}
			]]
		});
		
		$('#viewPaymentHisList').datagrid({
			url: '<%=request.getContextPath()%>/payment/getHisPaymentList?id=' + data.id,
			title:'历史付款申请单',
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			pagination:false,
			columns:[[
				{field:'code',title:'付款申请单编号',width:80, align:'center'},
				{field:'contractCode',title:'采购订单号',width:80, align:'center'},
				{field:'total',title:'申请金额(元)',width:80, align:'right',
					formatter:function(value, rowData, rowIndex){
						return fmoney(value);
					}	
				},
				{field:'applyDateStr',title:'申请日期',width:80, align:'center'},
				{field:'applyUserName',title:'申请人',width:80},
				{field:'status',title:'状态',width:80,formatter:
					function(value, rowData, rowIndex){
						if(value==0){
							return "未提交";
						}else if(value==10){
							return "采购部审批中";
						}else if(value==20){
							return "财务部审批中";
						}else if(value==30){
							return "已生效";
						}
					}
				}
			]]
		});
		
		$('#auditPaymentAuditList').datagrid({
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
		$('#auditWin').window('open'); 
	}
	
	//查看付款申请单
	function viewPayment(data){
		
		$('#viewPaymentTotal').html(fmoney(data.total));
		$('#viewPaymentApplyUser').html(data.applyUserName);
		$('#viewPaymentApplyDate').html(data.applyDateStr);
		$('#viewPaymentRemark').html(data.remark);
		$('#viewPaymentBill').html(fmoney(data.bill));
		
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
	
	//提交审批信息
	function submitAudit(data, option){
		MaskUtil.mask();
		data.seeStatus = $('#seeStatus').val();
		$('#auditForm').form('load', data);
		$('#auditOption').val(option);
		$('#auditForm').submit();
	}
	
	//导出付款申请单
	function printPayment(data){
		window.location = "<%=request.getContextPath()%>/payment/printPayment?id=" + data.id;
	}
</script>
</head>
<body>
	<input type="hidden" id="seeStatus" value="${seeStatus}">
	<table style="width:100%;height:auto;border: 1px solid #ccc; font-size: 12px;color: #888;padding: 5px;">
		<tr>
			<td style="text-align: right;">
				采购订单号：
			</td>
			<td style="text-align: left;">
				<input style="width: 75%; height: 17px;" class="queryParam" name="contractNo"/>
			</td>
			<td style="text-align: right;">
				采购订单名称：
			</td>
			<td style="text-align: left;">
				<input class="queryParam" name="contractName" style="width: 75%; height: 17px;"/>
			</td>
			<td style="text-align: right;">
				供应商名称：
			</td>
			<td style="text-align: left;">
				<input class="queryParam" name="supplierName" style="width: 75%; height: 17px;"/>
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
				<input type="hidden" class="queryParam" id="search_signDateBegin" name="signDateBeginStr"/>
			</td>
			<td style="text-align: left;">
				至
			</td>
			<td style="text-align: left;">
				<input class="easyui-datebox" id="signDateEnd" style="width: 155%; height: 23px;"/>
				<input type="hidden" class="queryParam" id="search_signDateEnd" name="signDateEndStr"/>
			</td>
			<td style="text-align: right;">
				到货日期：
			</td>
			<td style="text-align: left;">
				<input class="easyui-datebox" id="payDateBegin" style="width: 155%; height: 23px;"/>
				<input type="hidden" class="queryParam" id="search_payDateBegin" name="payDateBeginStr"/>
			</td>
			<td style="text-align: left;">
				至
			</td>
			<td style="text-align: left;">
				<input class="easyui-datebox" id="payDateEnd" style="width: 155%; height: 23px;"/>
				<input type="hidden" class="queryParam" id="search_payDateEnd" name="payDateEndStr"/>
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
	<table id="paymentList">
	</table>
	
	<div id="auditWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-search">
    	<input type="hidden" id="auditPaymentId">
   	  	<table id="viewPaymentList"></table>
   	  
   	  	<div style="height: 10px;"></div>
   	  
   	  	<table id="viewPaymentHisList"></table>
   	  
   	  	<div style="height: 10px;"></div>
        <table id="auditPaymentAuditList"></table>
   	  
   	  	<div style="height: 10px;"></div>
   	  
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
               			<td id="viewPaymentBill"></td>
               			
               			<td style="width: 10%; text-align: right;"></td>
               			<td ></td>
               			
               			<td style="width: 10%; text-align: right;"></td>
               			<td ></td>
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
	
	<form action="#" id="auditForm" method="post">
   		<input type="hidden" name="id">
   		<input type="hidden" id="auditOption" name="option">
   		<input type="hidden" name="seeStatus">
   		<input type="hidden" name="comment">
   	</form>
</body>
</html>