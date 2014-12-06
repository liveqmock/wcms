<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>生成计划审批</title>
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
		
		$('#productionPlanList').datagrid({
			url: '<%=request.getContextPath()%>/producPlan/getAuditPlanList?seeStatus=' + seeStatus,
			title: '生产计划列表',
			toolbar:[
				{iconCls : 'icon-search', text : '查看', 
					handler: function(){
						var data = $('#productionPlanList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要查看的数据' , 'warning');
					 		return;
					 	}
						
						viewProductPlan(data);
					}
				},
				{iconCls : 'icon-print', text : '导出', 
					handler: function(){
						var data = $('#productionPlanList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要查看的数据' , 'warning');
					 		return;
					 	}
						
						printProductPlan(data);
					}
				},
				{iconCls : 'icon-search', text : '审批', 
					handler: function(){
						var data = $('#productionPlanList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要编辑的数据' , 'warning');
					 		return;
					 	}
						
						if(data.status == seeStatus){
							auditProductPlan(data);	
						}else{
							msgShow('提示', '只能审批未审批的生产计划' , 'warning');
						}
					}
				},
				{iconCls : 'icon-ok', text : '通过', 
					handler: function(){
						var data = $('#productionPlanList').datagrid('getSelected');
						if(data==null){
	 						msgShow('提示', '请选中需要提交的数据' , 'warning');
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
			    		}else if(rowData.status > seeStatus){
			    			return '<div style="width:10px;height:10px;background-color:blue"></div>';
			    		}
			    	}
			    },
				{field:'order',title:'合同编号',width:80,
					formatter:function(value, rowData, rowIndex){
						return value.no;		
					}
				},
				{field:'clientName',title:'客户名称',width:80,
					formatter:function(value, rowData, rowIndex){
						return rowData.order.clientName;
					}
				},
				{field:'linkman',title:'联系人',width:80,
					formatter:function(value, rowData, rowIndex){
						return rowData.order.linkman;
					}
				},
				{field:'phone',title:'联系电话',width:80,
					formatter:function(value, rowData, rowIndex){
						return rowData.order.phone;
					}
				},
				{field:'signDate',title:'签订日期',width:80,
					formatter:function(value, rowData, rowIndex){
						return rowData.order.signDate;
					}
				},
				{field:'deliveryDate',title:'交货日期',width:80,
					formatter:function(value, rowData, rowIndex){
						return rowData.order.payDate;
					}
				},
				{field:'signName',title:'签单人',width:80,
					formatter:function(value, rowData, rowIndex){
						return rowData.order.signerName;
					}
				},
				{field:'status',title:'状态',width:80,
					formatter:function(value, rowData, rowIndex){
						if(value == seeStatus){
							return "未审批";
						}else if(value > seeStatus){
							return "已审批";
						}
					}
				}
			]],
			onDblClickRow:function(rowIndex, rowData) {  
				viewProductionPlan(); 
	        }
		});
		
		var p = $('#productionPlanList').datagrid('getPager'); 
		p.pagination({  
	        pageSize : 10,// 每页显示的记录条数，默认为20  
	        pageList : [ 10, 20, 30 ],// 可以设置每页记录条数的列表  
	        beforePageText : '第',// 页数文本框前显示的汉字  
	        afterPageText : '页    共 {pages} 页',  
	        displayMsg : '当前显示 {from} - {to} 条记录   共 {total} 条记录'   
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
		
		$('#viewDetailWin').window({
            title: '查看',
            width: 800,
            modal: true,
            shadow: true,
            closed: true,
            height: 350,
            top:0,
            left:50
        });
		
		$('#audit-pass').on('click', function(){
			var data = {"id":$('#planId').val()};
			if(!strIsNull($('#auditComment').val())){
				data.comment = $('#auditComment').val();
			}else{
				data.comment = "";
			}
			submitAudit(data, 1);
			$('#auditWin').window('close');
		});
		
		$('#audit-cancel').on('click', function(){
			var data = {"id":$('#planId').val()};
			
			if(strIsNull($('#auditComment').val())){
				msgShow('提示', '退回必须填写原因' , 'warning');
				return;
			}
			data.comment = $('#auditComment').val();
			submitAudit(data, 0);
			$('#auditWin').window('close');
		});
		
		$('#auditForm').form({
			url:'<%=request.getContextPath()%>/producPlan/submitAudit',
			onSubmit:function(){
				
			},
			success:function(data){
				var data = eval('(' + data + ')');
				MaskUtil.unmask();
				if(data.flag){
					$('#productionPlanList').datagrid('reload');
					msgShow('提示', '提交成功' , 'info');
				}else{
					msgShow('提示', '提交失败' , 'error');
				}
			}
		});
		
		$('#search-status').combobox({
			data:[{'id':0, 'text':'未审批'},{'id':1,'text':'已审批'}],
			valueField:'id',
			textField:'text',
			editable:false
		});
		
		$('#search-status').combobox('select', 0);
		
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
			queryParams.auditStatus = status;
			
			$('#productionPlanList').datagrid('options').queryParams = queryParams;
			$('#productionPlanList').datagrid('reload');
		});
	});
	
	function viewProductPlan(data){
		$('#viewNo').html(data.order.no);
		$('#viewName').html(data.order.name);
		$('#viewSignerName').html(data.order.signerName);
		$('#viewTotal').html(fmoney(data.order.total, 2));
		$('#viewSignDate').html(data.order.signDate);
		$('#viewClientName').html(data.order.clientName);
		$('#viewPayPlace').html(data.order.payPlace);
		$('#viewPayDate').html(data.order.payDate);
		$('#viewWarrantee').html(data.order.warrantee);
		$('#viewLinkman').html(data.order.linkman);
		$('#viewPhone').html(data.order.phone);
		$('#viewRemark').html(data.order.remark);
		
		$('#viewProductList').datagrid({
			url: '<%=request.getContextPath()%>/order/getOrderDetailList?orderId='+data.order.id,
			title:'产品清单',
			toolbar:[
				{iconCls : 'icon-search', text : '查看', 
					handler: function(){
						var data = $('#viewProductList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要查看的数据' , 'warning');
					 		return;
					 	}
						
						viewDetail(data);
					}
				}
			],			
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			columns:[[
				{field:'name',title:'产品名称',width:70},
				{field:'model',title:'型号',width:80},
				{field:'quantity',title:'数量',width:20, align:'right'},
				{field:'technicalParam',title:'技术参数',width:150}
			]]
		});
		
		$('#viewAuditLogList').datagrid({
			url: '<%=request.getContextPath()%>/audit/getAuditList?id='+data.id+'&type=2',
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
		
		$('#viewWin').window('open');
	}
	
	function auditProductPlan(data){
		$('#planId').val(data.id);
		
		$('#auditNo').html(data.order.no);
		$('#auditName').html(data.order.name);
		$('#auditSignerName').html(data.order.signerName);
		$('#auditTotal').html(fmoney(data.order.total, 2));
		$('#auditSignDate').html(data.order.signDate);
		$('#auditClientName').html(data.order.clientName);
		$('#auditPayPlace').html(data.order.payPlace);
		$('#auditPayDate').html(data.order.payDate);
		$('#auditWarrantee').html(data.order.warrantee);
		$('#auditLinkman').html(data.order.linkman);
		$('#auditPhone').html(data.order.phone);
		$('#auditRemark').html(data.order.remark);
		
		$('#auditProductList').datagrid({
			url: '<%=request.getContextPath()%>/order/getOrderDetailList?orderId='+data.order.id,
			title:'产品清单',
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			columns:[[
				{field:'name',title:'产品名称',width:150},
				{field:'quantity',title:'数量',width:20, align:'right'},
				{field:'technicalParam',title:'技术参数',width:150}
			]]
		});
		
		$('#auditAuditLogList').datagrid({
			url: '<%=request.getContextPath()%>/audit/getAuditList?id='+data.id+'&type=2',
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
	
	//导出
	function printProductPlan(data){
		window.location = "<%=request.getContextPath()%>/producPlan/printProductPlan?id=" + data.id;
	}
	
	//查看明细
	function viewDetail(data){
		$('#viewDetailName').html(data.name);
		$('#viewDetailModel').html(data.model);
		$('#viewDetailNum').html(data.quantity);
		$('#viewDetailParam').html(data.technicalParam);
		$('#viewDetailWin').window('open');
	}
</script>
</head>
<body>
	<input type="hidden" id="seeStatus" value="${seeStatus}">
	<table style="width:100%;height:auto;border: 1px solid #ccc; font-size: 12px;color: #888;padding: 5px;">
		<tr>
			<td style="text-align: right;">
				合同编号：
			</td>
			<td style="text-align: left;">
				<input class="queryParam" name="orderNo" style="width: 75%; height: 17px;"/>
			</td>
			<td style="text-align: right;">
				客户名称：
			</td>
			<td style="text-align: left;">
				<input class="queryParam" name="clientName" style="width: 75%; height: 17px;"/>
			</td>
			<td style="text-align: right;">
				状态：
			</td>
			<td style="text-align: left;">
				<input id="search-status" style="width: 150px; height: 23px;"/>
				<input type="hidden" class="queryParam" id="search-auditStatus" name="auditStatus">
			</td>
			<td style="text-align: right;">
				签单人：
			</td>
			<td style="text-align: left;">
				<input id="signerUser_search" style="width: 150px; height: 23px;"/>
				<input type="hidden" class="queryParam" id="search_signer" name="signer">
			</td>
		</tr>
		<tr>
			<td style="text-align: right;">
				签订日期：
			</td>
			<td style="text-align: left;">
				<input id="signDateBegin" class="easyui-datebox" style="width: 155%; height: 23px;"/>
				<input type="hidden" class="queryParam" id="search_signDateBegin" name="signDateBegin">
			</td>
			<td style="text-align: left;">
				至
			</td>
			<td style="text-align: left;">
				<input id="signDateEnd" class="easyui-datebox" style="width: 155%; height: 23px;"/>
				<input type="hidden" class="queryParam" id="search_signDateEnd" name="signDateEnd">
			</td>
			<td style="text-align: right;">
				交货日期：
			</td>
			<td style="text-align: left;">
				<input id="payDateBegin" class="easyui-datebox" style="width: 155%; height: 23px;"/>
				<input type="hidden" class="queryParam" id="search_payDateBegin" name="payDateBegin">
			</td>
			<td style="text-align: left;">
				至
			</td>
			<td style="text-align: left;">
				<input id="payDateEnd" class="easyui-datebox" style="width: 155%; height: 23px;"/>
				<input type="hidden" class="queryParam" id="search_payDateEnd" name="payDateEnd">
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
	<table id="productionPlanList"></table>
	
	<div id="viewWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-search">  
    	<table style="width: 100%;">
    	  		<tr style="line-height: 30px;">
    	  			<td style="width: 8%; text-align: right;">订单号：</td>
    	  			<td style="width: 15%; text-align: left;" id="viewNo"></td>
    	  		
    	  			<td style="width: 8%; text-align: right;">订单名称：</td>
    	  			<td style="width: 15%; text-align: left;" id="viewName"></td>
    	  		
    	  			<td style="width: 8%; text-align: right;">签单人：</td>
    	  			<td style="width: 8%; text-align: left;" id="viewSignerName"></td>
    	  		
    	  			<td style="width: 8%; text-align: right;">总金额(元)：</td>
    	  			<td style="width: 8%; text-align: left;" id="viewTotal"></td>
    	  		
    	  			<td style="width: 8%; text-align: right;">签订日期：</td>
    	  			<td style="width: 8%; text-align: left;" id="viewSignDate"></td>
    	  		</tr>
    	  		<tr style="line-height: 30px;">
    	  			<td style="text-align: right;">客户名称：</td>
    	  			<td style="text-align: left;" id="viewClientName"></td>
    	  		
    	  			<td style="text-align: right;">交付地址：</td>
    	  			<td style="text-align: left;" id="viewPayPlace"></td>
    	  		
    	  			<td style="text-align: right;">交付日期：</td>
    	  			<td style="text-align: left;" id="viewPayDate"></td>
    	  		
    	  			<td style="text-align: right;">质保期：</td>
    	  			<td style="text-align: left;" id="viewWarrantee"></td>
    	  		</tr>
    	  		<tr style="line-height: 25px;">
    	  			<td style="text-align: right;">联系人：</td>
    	  			<td style="text-align: left;" id="viewLinkman">
    	  				
    	  			</td>
    	  		
    	  			<td style="text-align: right;">联系电话：</td>
    	  			<td style="text-align: left;" id="viewPhone">
						
					</td>
    	  		
    	  			<td style="text-align: right;"></td>
    	  			<td style="text-align: left;">
    	  				
    	  			</td>
    	  		
    	  			<td style="text-align: right;"></td>
    	  			<td style="text-align: left;">
    	  				
    	  			</td>
    	  		</tr>
    	  		<tr style="line-height: 30px;">
    	  			<td style="text-align: right;">备注：</td>
    	  			<td style="text-align: left;" colspan="9" id="viewRemark"></td>
    	  		</tr>
    	  	</table>  
    	  
    	<table id="viewProductList"></table>
    	  
    	<div style="height: 10px;"></div>
    	
    	<table id="viewAuditLogList"></table>
  	</div>
  	
  	<div id="auditWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-search"> 
        <input type="hidden" id="planId"> 
    	<table style="width: 100%;">
    	  		<tr style="line-height: 30px;">
    	  			<td style="width: 8%; text-align: right;">订单号：</td>
    	  			<td style="width: 15%; text-align: left;" id="auditNo"></td>
    	  		
    	  			<td style="width: 8%; text-align: right;">订单名称：</td>
    	  			<td style="width: 15%; text-align: left;" id="auditName"></td>
    	  		
    	  			<td style="width: 8%; text-align: right;">签单人：</td>
    	  			<td style="width: 8%; text-align: left;" id="auditSignerName"></td>
    	  		
    	  			<td style="width: 8%; text-align: right;">总金额(元)：</td>
    	  			<td style="width: 8%; text-align: left;" id="auditTotal"></td>
    	  		
    	  			<td style="width: 8%; text-align: right;">签订日期：</td>
    	  			<td style="width: 8%; text-align: left;" id="auditSignDate"></td>
    	  		</tr>
    	  		<tr style="line-height: 30px;">
    	  			<td style="text-align: right;">客户名称：</td>
    	  			<td style="text-align: left;" id="auditClientName"></td>
    	  		
    	  			<td style="text-align: right;">交付地址：</td>
    	  			<td style="text-align: left;" id="auditPayPlace"></td>
    	  		
    	  			<td style="text-align: right;">交付日期：</td>
    	  			<td style="text-align: left;" id="auditPayDate"></td>
    	  		
    	  			<td style="text-align: right;">质保期：</td>
    	  			<td style="text-align: left;" id="auditWarrantee"></td>
    	  		</tr>
    	  		<tr style="line-height: 25px;">
    	  			<td style="text-align: right;">联系人：</td>
    	  			<td style="text-align: left;" id="auditLinkman">
    	  				
    	  			</td>
    	  		
    	  			<td style="text-align: right;">联系电话：</td>
    	  			<td style="text-align: left;" id="auditPhone">
						
					</td>
    	  		
    	  			<td style="text-align: right;"></td>
    	  			<td style="text-align: left;">
    	  				
    	  			</td>
    	  		
    	  			<td style="text-align: right;"></td>
    	  			<td style="text-align: left;">
    	  				
    	  			</td>
    	  		</tr>
    	  		<tr style="line-height: 30px;">
    	  			<td style="text-align: right;">备注：</td>
    	  			<td style="text-align: left;" colspan="9" id="auditRemark"></td>
    	  		</tr>
    	  	</table>  
    	  
    	<table id="auditProductList"></table>
    	  
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
  	
  	<div id="viewDetailWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-search">  
    	<table style="width: 95%; border-collapse: collapse;">
   	  		<tr style="line-height: 30px;">
   	  			<td style="width: 8%; text-align: right; border: solid #ccc 1px;">名称：</td>
   	  			<td style="width: 15%; text-align: left; border: solid #ccc 1px;" id="viewDetailName"></td>
   	  		</tr>
   	  		<tr style="line-height: 30px;">
   	  			<td style="text-align: right; border: solid #ccc 1px;">型号：</td>
   	  			<td style="text-align: left; border: solid #ccc 1px;" id="viewDetailModel"></td>
   	  		</tr>
   	  		<tr style="line-height: 25px;">
   	  			<td style="text-align: right; border: solid #ccc 1px;">数量：</td>
   	  			<td style="text-align: left; border: solid #ccc 1px;" id="viewDetailNum">
   	  				
   	  			</td>
   	  		</tr>
   	  		<tr style="line-height: 80px;">
   	  			<td style="text-align: right; border: solid #ccc 1px;">技术参数：</td>
   	  			<td style="text-align: left; border: solid #ccc 1px;" colspan="9" id="viewDetailParam"></td>
   	  		</tr>
   	  	</table>
  	</div>
</body>
</html>