<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>收款单审批</title>
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
		
		$('#gatheringList').datagrid({
			url: '<%=request.getContextPath()%>/gather/getAuditGatheringList?seeStatus=' + seeStatus,
			title:'收款单列表',
			toolbar:[
				{iconCls : 'icon-search', text : '查看', 
					handler: function(){
						var data = $('#gatheringList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要查看的数据' , 'warning');
					 		return;
					 	}
						
						viewGather(data);
					}
				},
				{iconCls : 'icon-search', text : '审批', 
					handler: function(){
						var data = $('#gatheringList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要审批的数据' , 'warning');
					 		return;
					 	}
						
						if(data.status == seeStatus){
							auditGather(data);	
						}else{
							msgShow('提示', '只能审批未审批的设计方案' , 'warning');
						}
					}
				},
				{iconCls : 'icon-ok', text : '通过', 
					handler: function(){
						var data = $('#gatheringList').datagrid('getSelected');
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
				{field:'orderNo',title:'订单号',width:80},
				{field:'code',title:'收款单编号',width:80},
				{field:'total',title:'收款金额',width:80, align:'right', 
					formatter:function(value, rowData, rowIndex){
						return fmoney(value);
					}	
				},
				{field:'gatherDate',title:'收款日期',width:80, align:'center'},
				{field:'realname',title:'收款人',width:80},
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
		
		var p = $('#gatheringList').datagrid('getPager'); 
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
			
			$('#gatheringList').datagrid('options').queryParams = queryParams;
			$('#gatheringList').datagrid('reload');
		});
		
		$('#audit-pass').on('click', function(){
			var data = {"id":$('#auditGatherId').val()};
			if(!strIsNull($('#auditComment').val())){
				data.comment = $('#auditComment').val();
			}else{
				data.comment = "";
			}
			submitAudit(data, 1);
			$('#auditWin').window('close');
		});
		
		$('#audit-cancel').on('click', function(){
			var data = {"id":$('#auditGatherId').val()};
			
			if(strIsNull($('#auditComment').val())){
				msgShow('提示', '退回必须填写原因' , 'warning');
				return;
			}
			data.comment = $('#auditComment').val();
			submitAudit(data, 0);
			$('#auditWin').window('close');
		});
		
		$('#auditForm').form({
			url:'<%=request.getContextPath()%>/gather/submitAudit',
			onSubmit:function(){
				
			},
			success:function(data){
				var data = eval('(' + data + ')');
				MaskUtil.unmask();
				if(data.flag){
					$('#gatheringList').datagrid('reload');
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
	});
	
	//审批收款单
	function auditGather(data){
		$('#auditGatherId').val(data.id);
		
		var array = new Array(1);
		array[0] = data;
		$('#viewGatheringList').datagrid({
			data: array,
			title:'本次收款单',
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			pagination:false,
			columns:[[
				{field:'code',title:'收款单编号',width:80, align:'center'},
				{field:'orderNo',title:'订单号',width:80, align:'center'},
				{field:'total',title:'收款金额',width:80, align:'right',
					formatter:function(value, rowData, rowIndex){
						return fmoney(value);
					}	
				},
				{field:'gatherDate',title:'收款日期',width:80, align:'center'},
				{field:'realname',title:'收款人',width:80}
			]]
		});
		
		$('#viewGatheringHisList').datagrid({
			url: '<%=request.getContextPath()%>/gather/getHisGatherList?id=' + data.id,
			title:'历史收款单',
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			pagination:false,
			columns:[[
				{field:'code',title:'收款单编号',width:80, align:'center'},
				{field:'orderNo',title:'订单号',width:80, align:'center'},
				{field:'total',title:'收款金额',width:80, align:'right',
					formatter:function(value, rowData, rowIndex){
						return fmoney(value);
					}	
				},
				{field:'gatherDate',title:'收款日期',width:80, align:'center'},
				{field:'realname',title:'收款人',width:80},
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
						}
					}
				}
			]]
		});
		
		$('#auditGatherAuditList').datagrid({
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
		$('#auditWin').window('open'); 
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
	
	//提交审批信息
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
	<input type="hidden" id="seeStatus" value="${seeStatus}">
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
	<table id="gatheringList">
	</table>
	
	<div id="auditWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-search">
        		
        <input type="hidden" id="auditGatherId">
    	  <table id="viewGatheringList"></table>
    	  
    	  <div style="height: 10px;"></div>
    	  
    	  <table id="viewGatheringHisList"></table>
    	  
    	  <div style="height: 10px;"></div>
          <table id="auditGatherAuditList"></table>
    	  
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
	
	<form action="#" id="auditForm" method="post">
   		<input type="hidden" name="id">
   		<input type="hidden" id="auditOption" name="option">
   		<input type="hidden" name="seeStatus">
   		<input type="hidden" name="comment">
   	</form>
</body>
</html>