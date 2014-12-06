<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>采购计划录入</title>
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
	var seeStatus;
	$(function(){
		seeStatus = $('#seeStatus').val();
		$('#procurement_list').datagrid({
			url: '<%=request.getContextPath()%>/procurementPlan/getAuditPlanList?seeStatus='+seeStatus,
			toolbar:[
					{iconCls : 'icon-search', text : '查看', 
						handler: function(){
							var data = $('#procurement_list').datagrid('getSelected');
							if(data==null){
						 		msgShow('提示', '请选中需要查看的记录' , 'warning');
						 		return;
						 	}
							
							viewPlan(data);
						}
					},{iconCls : 'icon-search', text : '审批', 
						handler: function(){
							var data = $('#procurement_list').datagrid('getSelected');
							if(data==null){
								msgShow('提示', '请选中需要审批的记录' , 'warning');
						 		return;
						 	}
							
							appPlan(data);
						}
					},
					{iconCls : 'icon-ok', text : '通过', 
						handler: function(){
							var data = $('#procurement_list').datagrid('getSelected');
							if(data==null){
						 		msgShow('提示', '请选中需要提交的记录' , 'warning');
						 		return;
						 	}
							
							if(data.status == seeStatus){
								submitAudit(data, 1);	
							}else{
								msgShow('提示', '只能通过未审批的记录' , 'warning');
							}
						}
					}],
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			pagination:true,
			columns:[[
				{field:'id',  width:10, align:'center',
					formatter:function(value, rowData, rowIndex){
						if(rowData.status == seeStatus){
							return '<div style="width:10px;height:10px;background-color:yellow"></div>';	
						}else if(rowData.status > seeStatus){
							return '<div style="width:10px;height:10px;background-color:blue"></div>';
						}
					}
				},      
				{field:'applyUser',title:'计划人编号',width:80,hidden:true},
				{field:'code',title:'采购编号',width:80},
				{field:'applyUserName',title:'计划人',width:80},
				{field:'applyDate',title:'计划日期',width:80},
				{field:'status',title:'状态',width:80,
					formatter:function(value, rowData, rowIndex){
						if(value == 0){
							return "未提交";
						}else if(value == 10){
							return "采购部审批中";
						}else if(value == 20){
							return "财务部审批中";
						}else if(value == 30){
							return "已生效";
						}else if(value == -5555){
							return "退回";
						}	
					}
				}
			]],
			onDblClickRow:function(rowIndex, rowData) {  
				viewPlan(); 
	        },
		});
		
		var p = $('#procurement_list').datagrid('getPager'); 
		p.pagination({  
	        pageSize : 10,// 每页显示的记录条数，默认为20  
	        pageList : [ 10, 20, 30 ],// 可以设置每页记录条数的列表  
	        beforePageText : '第',// 页数文本框前显示的汉字  
	        afterPageText : '页    共 {pages} 页',  
	        displayMsg : '当前显示 {from} - {to} 条记录   共 {total} 条记录'   
	    });
		
		$('#search-status').combobox({
			data:[{'id':0,'text':'未审批'},{'id':1,'text':'已审批'}],
			valueField:'id',
			textField:'text',
			editable:false
		});
		
		$('#search-status').combobox('select', 0);
		
		$('#search').on('click', function(){
			$('#search_applyUser_code').val($('#search_applyUser_name').combobox('getValue'));
			$('#search_applyDateBegin').val($('#applyDateBegin').datebox('getValue'));
			$('#search_applyDateEnd').val($('#applyDateEnd').datebox('getValue'));
			
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
			
			$('#procurement_list').datagrid('options').queryParams = queryParams;
			$('#procurement_list').datagrid('reload');
		});
		
		$('#search_applyUser_name').combobox({
			valueField:'id',
			textField:'text',
			editable:false
		});
		
		$.ajax({
			url:'<%=request.getContextPath()%>/user/getUsersByRole?roleCode=CGJHZDY',
			type:'post',
			dataType:'json',
			success:function(data){
				data.unshift({"id":"", "text":"全部"});
				$('#search_applyUser_name').combobox('loadData', data);
			},
			async:true
		});
		
		$('.applyUser').combobox({
			url:'<%=request.getContextPath()%>/user/getUsersByRole?roleCode=CGJHZDY',
			valueField:'id',
			textField:'text',
			editable:false,
			required:true
		});
		
		$('.add-datebox').datebox({
			editable:false,
			required:true
		});
		
		$('#viewWin').window({
            title: '查看采购计划',
            width: 1000,
            modal: true,
            shadow: true,
            closed: true,
            height: 500,
            top:0,
            left:50
        });
		
		
		$('#appWin').window({
            title: '审批采购计划',
            width: 1000,
            modal: true,
            shadow: true,
            closed: true,
            height: 500,
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
		});
		
		$('#audit-cancel').on('click', function(){
			var data = {"id":$('#planId').val()};
			
			if(strIsNull($('#auditComment').val())){
				msgShow('提示', '退回必须填写原因' , 'warning');
				return;
			}
			data.comment = $('#auditComment').val();
			submitAudit(data, 0);
		});
		
	});
	
	//查看采购计划
	function viewPlan(data){
		$('#view_procurementDetail_List').datagrid({
			url: '<%=request.getContextPath()%>/procurementPlan/getProcurementDetailList?planId='+data.id,
			title:'采购计划明细',
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			columns:[[
				{field:'id',title:'ID',width:80,hidden:true},
				{field:'planId',title:'planId',width:80,hidden:true},
				{field:'goodsId',title:'goodsId',width:80,hidden:true},
				{field:'name',title:'名称',width:80},
				{field:'model',title:'规格型号',width:80},
				{field:'brand',title:'品牌',width:80},
				{field:'purpose',title:'用途',width:80},
				{field:'amount',title:'数量',width:80},
				{field:'unitName',title:'单位',width:80},
				{field:'budgetSum',title:'预算金额',width:80},
				{field:'expectArrivalDate',title:'期望到货日期',width:80},
				{field:'remark',title:'备注',width:80}
			]]
		});
		
		$('#viewPlanAtta').datagrid({
			url: '<%=request.getContextPath()%>/procurementPlan/getProcurementPlanAttaList?planId='+data.id,
			title:'附件清单',
			toolbar:[
				{iconCls : 'icon-ok', text : '下载附件', 
					handler: function(){
						var data = $('#viewPlanAtta').datagrid('getSelected');
						if(data==null){
							 msgShow('提示', '请选中需要下载的附件' , 'warning');
							 return;
						}
						window.open('<%=request.getContextPath()%>/procurementPlan/downloadProcurementPlanAtta?attaId='+data.id);
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
		
		$('#viewAuditLogList').datagrid({
			url: '<%=request.getContextPath()%>/audit/getAuditList?id='+data.id+'&type=6',
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
		
		$('#view_applyUser').html(data.applyUserName);
		$('#view_applyDate').html(data.applyDate);
		
		$('#viewWin').window({"title":"查看   采购计划编号:"+data.code});
		$('#viewWin').window('open'); 
	}
	
	//审批采购计划
	function appPlan(data){
		$("#planId").val(data.id);
		$('#app_procurementDetail_List').datagrid({
			url: '<%=request.getContextPath()%>/procurementPlan/getProcurementDetailList?planId='+data.id,
			title:'采购计划明细',
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			columns:[[
				{field:'id',title:'ID',width:80,hidden:true},
				{field:'planId',title:'planId',width:80,hidden:true},
				{field:'goodsId',title:'goodsId',width:80,hidden:true},
				{field:'name',title:'名称',width:80},
				{field:'model',title:'规格型号',width:80},
				{field:'brand',title:'品牌',width:80},
				{field:'purpose',title:'用途',width:80},
				{field:'amount',title:'数量',width:80},
				{field:'unitName',title:'单位',width:80},
				{field:'budgetSum',title:'预算金额',width:80,align:'right',
					formatter:function(value, rowData, rowIndex){
						return fmoney(value);
					}
				},
				{field:'expectArrivalDate',title:'期望到货日期',width:80},
				{field:'remark',title:'备注',width:80}
			]]
		});
		
		$('#appPlanAtta').datagrid({
			url: '<%=request.getContextPath()%>/procurementPlan/getProcurementPlanAttaList?planId='+data.id,
			title:'附件清单',
			toolbar:[
				{iconCls : 'icon-ok', text : '下载附件', 
					handler: function(){
						var data = $('#appPlanAtta').datagrid('getSelected');
						if(data==null){
							 msgShow('提示', '请选中需要下载的附件' , 'warning');
							 return;
						}
						window.open('<%=request.getContextPath()%>/procurementPlan/downloadProcurementPlanAtta?attaId='+data.id);
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
		
		$('#appAuditLogList').datagrid({
			url: '<%=request.getContextPath()%>/audit/getAuditList?id='+data.id+'&type=6',
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
		
		$('#app_applyUser').html(data.applyUserName);
		$('#app_applyDate').html(data.applyDate);
		
		$('#appWin').window({"title":"审批   采购计划编号:"+data.code});
		$('#appWin').window('open');  
	}
	
	function submitAudit(data, option){
		MaskUtil.mask();
		$.ajax({
			url:'<%=request.getContextPath()%>/procurementPlan/submitAudit?id='+data.id+'&option='+option+'&seeStatus='+seeStatus,
			type:'post',
			dataType:'json',
			success:function(data){
				MaskUtil.unmask();
				if(data.flag){
					$('#procurement_list').datagrid('reload');
					$('#appWin').window('close');
					msgShow('提示', '提交成功' , 'info');
				}else{
					msgShow('提示', '提交失败' , 'error');
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
	<input type="hidden" id="seeStatus" value="${seeStatus}"/>
	<table style="width:100%;height:auto;border: 1px solid #ccc; font-size: 12px;color: #888;padding: 5px;">
		<tr style="padding-bottom: 35px;">
			<td style="text-align: right;">
				采购编号：
			</td>
			<td style="text-align: left;">
				<input class="queryParam" name="code" style="width: 75%; height: 17px;"/>
			</td>
			<td style="text-align: right;">
				计划人：
			</td>
			<td style="text-align: left;">
				<input id="search_applyUser_name" style="width: 150px; height: 22px;"/>
				<input type="hidden" class="queryParam" name="applyUser" id="search_applyUser_code">
			</td>
			<td style="text-align: right;">
				计划日期：
			</td>
			<td style="text-align: left;">
				<input class="easyui-datebox" id="applyDateBegin" style="width: 155%; height: 23px;"/>
				<input type="hidden" class="queryParam" id="search_applyDateBegin" name="applyDateBegin"/>
			</td>
			<td style="text-align: left;">
				至
			</td>
			<td style="text-align: left;">
				<input class="easyui-datebox" id="applyDateEnd" style="width: 155%; height: 23px;"/>
				<input type="hidden" class="queryParam" id="search_applyDateEnd" name="applyDateEnd"/>
			</td>
		</tr>
		<tr  style="padding-bottom: 35px;">
			<td style="text-align: right;">
				状态：
			</td>
			<td style="text-align: left;">
				<input id="search-status" style="width: 150px; height: 23px;"/>
			</td>
			<td colspan=5>
			</td>
			<td style="text-align: center;" colspan="2">
				<a id="search" class="easyui-linkbutton" style="height: 25px;" iconCls="icon-search">搜索</a>
			</td>
		</tr>
	</table>
	<div style="height: 10px;"></div>
	<table id="procurement_list">
	</table>
	<div id="viewWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-search">  
    	  <table style="width: 100%;">
    	  	<tr style="line-height: 25px;">
    	  		<td style="text-align: right;">计划人：</td>
    	  		<td style="text-align: left;" id="view_applyUser"></td>
    	  		
    	  		<td style="text-align: right;">计划日期：</td>
    	  		<td style="text-align: left;" id="view_applyDate"></td>
    	  	</tr>
    	  	<!-- <tr style="line-height: 25px;">
    	  		<td style="text-align: right;">备注：</td>
    	  		<td style="text-align: left;" colspan="9">1.XXXXXXXX   2.XXXXXX</td>
    	  	</tr> -->
    	  </table>
    	  
    	  <table id="view_procurementDetail_List"></table>
    	  
    	  	<div style="height: 10px;"></div>
    	  
    	  	<table id="viewPlanAtta"></table>
    	  	
    	  	<div style="height: 10px;"></div>
    	  
    	  <table id="viewAuditLogList"></table>
    	  
  	</div>
  	
  	<div id="appWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-search">  
    	<form action="#" method="post">
    	<input type="hidden" id="planId"/>
   			<table style="width: 100%;">
    	  	<tr style="line-height: 25px;">
    	  		<td style="text-align: right;">计划人：</td>
    	  		<td style="text-align: left;" id="app_applyUser"></td>
    	  		
    	  		<td style="text-align: right;">计划日期：</td>
    	  		<td style="text-align: left;" id="app_applyDate"></td>
    	  	</tr>
    	  </table>
    	  
    	 <table id="app_procurementDetail_List"></table>
    	  
    	  	<div style="height: 10px;"></div>
    	  
    	  	<table id="appPlanAtta"></table>
    	  	
    	  	<div style="height: 10px;"></div>
    	  
    	  <table id="appAuditLogList"></table>
    	  
    	  	<table style="width: 100%;">
    	  		<tr>
    	  			<td style="width: 70%;">
    	  				<textarea rows="4" cols="110" id="auditComment"></textarea>
    	  			</td>
    	  			<td style="text-align: center;">
    	  				<a id="audit-pass" class="easyui-linkbutton" iconCls="icon-ok">通过</a>
    	  				<a id="audit-cancel" class="easyui-linkbutton" iconCls="icon-cancel">退回</a>
    	  			</td>
    	  		</tr>
    		</table>
    	</form>
  	</div>
</body>
</html>