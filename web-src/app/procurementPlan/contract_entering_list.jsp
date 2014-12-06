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

<script type="text/javascript">
	$(function(){
		$('.datebox').datebox({
			editable:false
		});
		
		$('#contract_list').datagrid({
			url: '<%=request.getContextPath()%>/contract/getProcurementContractList',
			toolbar:[{iconCls : 'icon-add', text : '新增', 
				handler: function(){
					addContract();
				}
			},{iconCls : 'icon-edit', text : '编辑', 
				handler: function(){
					var data = $('#contract_list').datagrid('getSelected');
					if(data==null){
				 		msgShow('提示', '请选中需要编辑的数据' , 'warning');
				 		return;
				 	}
					if(data.status == 0 || data.status == -5555){
						editContract(data);
					}else{
						msgShow('提示', '只能编辑未提交或退回的记录' , 'warning');
					}
					
				}
			},{iconCls : 'icon-search', text : '查看', 
				handler: function(){
					var data = $('#contract_list').datagrid('getSelected');
					if(data==null){
				 		msgShow('提示', '请选中需要查看的数据' , 'warning');
				 		return;
				 	}
					viewContract(data);
				}
			},
			{iconCls : 'icon-ok', text : '提交', 
				handler: function(){
					var data = $('#contract_list').datagrid('getSelected');
					if(data==null){
				 		msgShow('提示', '请选中需要提交的数据' , 'warning');
				 		return;
				 	}
					
					if(data.status == 0 || data.status == -5555){
						submitContract(data);	
					}else{
						msgShow('提示', '只能提交未提交或退回的记录' , 'warning');
					}
				}
			},
			{iconCls : 'icon-remove', text : '删除', 
				handler: function(){
					var data = $('#contract_list').datagrid('getSelected');
					if(data==null){
				 		msgShow('提示', '请选中需要删除的数据' , 'warning');
				 		return;
				 	}
					
					if(data.status == 0 || data.status == -5555){
						deleteContract(data);
					}else{
						msgShow('提示', '只能删除未提交或退回的记录' , 'warning');
					}
				}
			}],
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			pagination:true,
			columns:[[
				{field:'id',  width:20, align:'center',
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
				{field:'code',title:'订单号',width:80},
				{field:'name',title:'订单名称',width:80},
				{field:'supplier',title:'供应商',width:80},
				{field:'supplierLinkman',title:'供应商联系人',width:80},
				{field:'supplierPhone',title:'供应商联系电话',width:80},
				{field:'signUser',title:'签单人编号',width:80,hidden:true},
				{field:'signUserName',title:'签单人',width:80},
				{field:'signDateStr',title:'签订日期',width:80},
				{field:'sum',title:'总金额(元)',width:80,align:'right',
					formatter:function(value, rowData, rowIndex){
						return fmoney(value);	
					}
				},
				{field:'receiveUser',title:'收货人编号',width:80,hidden:true},
				{field:'receiveUserName',title:'收货人',width:80},
				{field:'receiveTimeStr',title:'到货日期',width:80},
				{field:'remark',title:'备注',width:80},
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
		});
		//分页显示
		var p = $('#contract_list').datagrid('getPager'); 
		p.pagination({  
	        pageSize : 10,// 每页显示的记录条数，默认为20  
	        pageList : [ 10, 20, 30 ],// 可以设置每页记录条数的列表  
	        beforePageText : '第',// 页数文本框前显示的汉字  
	        afterPageText : '页    共 {pages} 页',  
	        displayMsg : '当前显示 {from} - {to} 条记录   共 {total} 条记录'   
	    });
		//查询界面状态下拉选项生成
		$('#search-status').combobox({
			data:[{'id':'-1', 'text':'全部'},{'id':-5555,'text':'退回'},
			      {'id':0,'text':'未提交'},{'id':10,'text':'采购部审批中'},{'id':20,'text':'财务部审批中'},
			      {'id':30,'text':'已生效'}
			     ],
			valueField:'id',
			textField:'text',
			editable:false
		});
		//默认选择‘全部’
		$('#search-status').combobox('select', -1);
		//查询按钮单击事件
		$('#search').on('click', function(){
			$('#signerUser_search').val($('#signerUser_search_combobox').combobox('getValue'));
			$('#receiveUser_search').val($('#receiveUser_search_combobox').combobox('getValue'));
			$('#signDateBegin_search').val($('#signDateBegin').datebox('getValue'));
			$('#signDateEnd_search').val($('#signDateEnd').datebox('getValue'));
			$('#receiveTimeBegin_search').val($('#receiveTimeBegin').datebox('getValue'));
			$('#receiveTimeEnd_search').val($('#receiveTimeEnd').datebox('getValue'));
			//封装查询条件参数
			var queryParams = {};
			var params = $('.queryParam');
			for(i=0;i<params.length;i++){
				if($(params[i]).val() != ''){
					queryParams[$(params[i]).attr('name')] = $(params[i]).val();
				}
			}
			//获取‘状态’下拉值
			var status = $('#search-status').combobox('getValue');
			if(status != -1){
				queryParams.status = status;	
			}
			//grid传递参数赋值并重新加载grid
			$('#contract_list').datagrid('options').queryParams = queryParams;
			$('#contract_list').datagrid('reload');
		});
		//新增采购订单窗口初始化
		$('#addWin').window({
            title: '新增采购订单',
            width: 1100,
            modal: true,
            shadow: true,
            closed: true,
            height: 350,
            top:0,
            left:50
        });
		//设置类日历控件
		$('.add-datebox').datebox({
			editable:false,
			required:true
		});
		//新增界面签单人下拉框
		$('.signUserCombobox').combobox({
			url:'<%=request.getContextPath()%>/user/getUsersByRole?roleCode=CGY',
			valueField:'id',
			textField:'text',
			editable:false,
			required:true
		});
		//新增介面收货人下拉框
		//$('.receiveUserCombobox').combobox({
			//url:'<%=request.getContextPath()%>/user/getUsersByRole?roleCode=CKGLY',
			//valueField:'id',
			//textField:'text',
			//editable:false,
			//required:true
		//});
		
		$('#buy_company').combobox({
			data:[{'value':'大通','text':'大通'},{'value':'四海大通','text':'四海大通'}],
			valueField:'value',
			textField:'text',
			editable:false,
			required:true
		});
		
		//新增采购订单提交
		$('#addForm').form({
			url:'<%=request.getContextPath()%>/contract/saveContract',
			onSubmit:function(){
				$('#signUser_add').val($('#signUser_add_combobox').combobox('getValue'));
				//$('#receiveUser_add').val($('#receiveUser_add_combobox').combobox('getValue'));
				$('#add_company').val($('#buy_company').combobox('getValue'));
				return $(this).form('validate');
			},
			success:function(data){
				var data = eval('(' + data + ')');
				if(data.flag){
					$('#addWin').window('close');
					$('#contract_list').datagrid('reload');
					$('#addForm').form('reset');
					editContract(data.data);
				}else{
					msgShow('提示','保存失败','error');
				}
			}
		});
		
		$('#add-save').on('click', function(){
			$('#addForm').submit();
		});
		//编辑采购订单窗口初始化
		$('#editWin').window({
            title: '编辑采购订单',
            width: 1100,
            modal: true,
            shadow: true,
            closed: true,
            height: 550,
            top:0,
            left:50
        });
		$('#editForm').form({
			url:'<%=request.getContextPath()%>/contract/updateContract',
			onSubmit:function(){
				$('#signUser_edit').val($('#signUser_edit_combobox').combobox('getValue'));
				$('#receiveUser_edit').val($('#receiveUser_edit_combobox').combobox('getValue'));
				return $(this).form('validate');
			},
			success:function(data){
				var data = eval('(' + data + ')');
				if(data.flag){
					msgShow('提示','保存成功','info');
					$('#editWin').window('close');
					$('#contract_list').datagrid('reload');
				}else{
					msgShow('提示','保存失败','error');
				}
			}
		});
		
		$('#edit-save').on('click', function(){
			$('#editForm').submit();
		});
		//编辑采购订单明细窗口初始化
		$('#addDetailWin').window({
			title: '新增物品',
			width: 500,
			modal: true,
            shadow: true,
            closed: true,
            height: 500,
            top:0,
            left:200
		});
		//选择采购计划(获取未生成订单、状态为已生效的采购计划明细列表信息)
		$('#choose-plan').on('click', function(){
			$('#plan_list').datagrid({url:'<%=request.getContextPath()%>/procurementPlan/getPlanListByCondition'});
			$('#planWin').window('open');
		});
		//采购计划明细列表窗口初始化
		$('#planWin').window({
            title: '采购计划列表',
            width: 1100,
            modal: true,
            shadow: true,
            closed: true,
            height: 550,
            top:0,
            left:50
        });
		
		//采购计划明细列表初始化
		$('#plan_list').datagrid({
			title:'采购计划明细',
			toolbar:[
				{iconCls : 'icon-ok', text : '确认选择', 
				 handler: 
					function(){
					 	var data = $('#plan_list').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要选择的数据' , 'warning');
					 		return;
					 	}
						selectPlan(data);
				 	}
				}
			],
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			pagination:true,
			columns:[[
			    {field:'id',title:'ID',width:80,hidden:true},
				{field:'planId',title:'planId',width:80,hidden:true},
				{field:'code',title:'采购编号',width:80},
				{field:'applyUserName',title:'计划人',width:80},
				{field:'applyDate',title:'计划日期',width:80},
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
		
		var p1 = $('#plan_list').datagrid('getPager'); 
		p1.pagination({  
	        pageSize : 10,// 每页显示的记录条数，默认为20  
	        pageList : [ 10, 20, 30 ],// 可以设置每页记录条数的列表  
	        beforePageText : '第',// 页数文本框前显示的汉字  
	        afterPageText : '页    共 {pages} 页',  
	        displayMsg : '当前显示 {from} - {to} 条记录   共 {total} 条记录'   
	    });
		
		//搜索采购计划明细
		$('#plan_search').on('click', function(){
			var queryParams = {};
			$("#search_applyUser_code").val($("#search_applyUser_name").combobox('getValue'));
			var params = $('.plan_queryParam');
			for(i=0;i<params.length;i++){
				if($(params[i]).val() != ''){
					queryParams[$(params[i]).attr('name')] = $(params[i]).val();
				}
			}
			$('#plan_list').datagrid('options').queryParams = queryParams;
			$('#plan_list').datagrid('reload');
		});
		//加载采购计划查询页面签单人下拉选项
		$('#search_applyUser_name').combobox({
			valueField:'id',
			textField:'text',
			editable:false
		});
		//加载采购计划查询页面签单人下拉选项数据
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
		//保存采购订单明细
		$('#addDetailForm').form({
			onSubmit:function(){
				return $(this).form('validate');
			},
			success:function(data){
				var data = eval('(' + data + ')');
				if(data.flag){
					msgShow('提示','保存成功','info');
					$('#addDetailWin').window('close');
					$('#add_ContractDetail_list').datagrid('reload');
				}else{
					msgShow('提示','保存失败','error');
				}
			},
			error:function(){
   				msgShow('提示','保存失败','error');
   			}
		});
		
		$('#addDetail-save').on('click', function(){
			$('#addDetailForm').submit();
		});
		//采购订单附件添加窗口初始化
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
		//附件保存
		$('#attaForm').form({
			url:'<%=request.getContextPath()%>/contract/addAtta',
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
					$('#add_Contract_Atta_list').datagrid('reload');
					$('#addAttaWin').window('close');
				}else{
					msgShow('提示','上传失败','error');
				}
			}
		});
		
		$('#atta_upload').on('click', function(){
			$('#attaForm').submit();
		});
		
		//查看采购订单界面初始化
		$('#viewWin').window({
            title: '查看采购订单',
            width: 1000,
            modal: true,
            shadow: true,
            closed: true,
            height: 500,
            top:0,
            left:50
        });
		
		//选择物品
		$('#choose-goods').on('click', function(){
			$('#tt').tree({
        	    url:'<%=request.getContextPath()%>/sys/getGoodsTypeTree',
        	    onClick: function(node){
        	    	$('#tid').val(node.id);
        			$('#goodsList').datagrid({url:'<%=request.getContextPath()%>/sys/getGoodsByTid?tid=' + node.id});
        		}
        	});
			$('#goodsWin').window('open');
		});
		
		$('#goodsWin').window({
			title: '选择物品',
			width: 900,
			modal: true,
            shadow: true,
            closed: true,
            height: 560,
            top:0,
            left:0
		});
		
		$('#goodsList').datagrid({
			title:'物品库',
			toolbar:[
				{iconCls : 'icon-add', text : '新增物品', 
				 handler: 
					function(){
					 	if(strIsNull($('#tid').val())){
					 		msgShow('提示','请先选定类别,再添加物品','info');
					 		return;
					 	}
						$('#addGoodsWin').window('open');
				 	}
				},
				{iconCls : 'icon-ok', text : '确认选择', 
				 handler: 
					function(){
					 	var data = $('#goodsList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要选择的数据' , 'warning');
					 		return;
					 	}
						selectGoods(data);
				 	}
				}
			],
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			pagination:true,
			columns:[[
			    {field:'id',title:'ID',width:80,hidden:true},      
				{field:'name',title:'名称',width:80},
				{field:'model',title:'规格',width:80},
				{field:'brand',title:'品牌',width:80},
				{field:'unitName',title:'单位',width:80},
				{field:'remark',title:'备注',width:80}
			]]
		});
		
		var p1 = $('#goodsList').datagrid('getPager'); 
		p1.pagination({  
	        pageSize : 10,// 每页显示的记录条数，默认为20  
	        pageList : [ 10, 20, 30 ],// 可以设置每页记录条数的列表  
	        beforePageText : '第',// 页数文本框前显示的汉字  
	        afterPageText : '页    共 {pages} 页',  
	        displayMsg : '当前显示 {from} - {to} 条记录   共 {total} 条记录'   
	    });
	});
	
	
	//新增采购订单
	function addContract(){
		$('#addWin').window('center');
		$('#addWin').window('open');
	}
	//编辑采购订单
	function editContract(data){
		$('#editWin').window({"title":"编辑    采购订单编号:"+data.code});
		$('#add_detail_contractId').val(data.id);
		$("#atta_contractId").val(data.id);
		//$('#atta_orderId').val(data.id);
		
		$('#editForm').form('load', data);
		$('#edit_company').html(data.company);
		$('#signUser_edit_combobox').combobox('select', data.signUser);
		//$('#receiveUser_edit_combobox').combobox('select', data.receiveUser);
		$('#edit_receiveUserName').val(data.receiveUserName);
		
		$('#add_ContractDetail_list').datagrid({
			url: '<%=request.getContextPath()%>/contract/getDetailList?contractId='+data.id,
			title:'采购订单明细',
			toolbar:[{iconCls : 'icon-add', text : '添加明细', 
				handler: function(){
					addDetail();
				}
			},{iconCls : 'icon-edit', text : '编辑', 
				handler: function(){
					var data = $('#add_ContractDetail_list').datagrid('getSelected');
					if(data==null){
				 		msgShow('提示', '请选中需要编辑的数据' , 'warning');
				 		return;
				 	}
					editDetail(data);	
				}
			},{iconCls : 'icon-remove', text : '删除', 
				handler: function(){
					var data = $('#add_ContractDetail_list').datagrid('getSelected');
					if(data==null){
				 		msgShow('提示', '请选中需要删除的数据' , 'warning');
				 		return;
				 	}
					deleteDetail(data);	
				}
			}],
			editCell:true,
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			columns:[[
				{field:'id',title:'ID',width:80,hidden:true},
				{field:'contractId',title:'采购订单ID',width:80,hidden:true},
				{field:'planId',title:'采购计划ID',width:80,hidden:true},
				{field:'name',title:'名称',width:80},
				{field:'model',title:'规格型号',width:80},
				{field:'brand',title:'品牌',width:80},
				{field:'purpose',title:'用途',width:80},
				{field:'amount',title:'数量',width:80,align:'right'},
				{field:'unit',title:'单位',width:80},
				{field:'unitPrice',title:'单价',width:80,align:'right',
					formatter:function(value, rowData, rowIndex){
						return fmoney(value);	
					}
				},
				{field:'dSum',title:'总金额',width:80, align:'right',
					formatter:function(value, rowData, rowIndex){
						return fmoney(value);	
					}
				},
				{field:'remark',title:'备注',width:80}
			]]
		});
		$('#add_Contract_Atta_list').datagrid({
			url: '<%=request.getContextPath()%>/contract/getContractAttaList?contractId='+data.id,
			title:'附件清单',
			toolbar:[
			    {iconCls : 'icon-add', text : '添加附件', 
					handler: function(){
						addAtta(); 
					}
				},
				{iconCls : 'icon-ok', text : '下载附件', 
					handler: function(){
						var data = $('#add_Contract_Atta_list').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要下载的附件' , 'warning');
					 		return;
					 	}
						window.open('<%=request.getContextPath()%>/contract/downloadContractAtta?id='+data.id);
					}
				},
				{iconCls : 'icon-remove', text : '删除附件', 
					handler: function(){
						var data = $('#add_Contract_Atta_list').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要删除的附件' , 'warning');
					 		return;
					 	}
						MaskUtil.mask();
						$.ajax({
		        			url:"<%=request.getContextPath()%>/contract/deleteContractAtta?id=" + data.id,
		    				type:"post",
		    				dataType:"json",
		    				success:function(data, textStatus){
		    					MaskUtil.unmask();
		    					if(data.flag){
		    						msgShow('提示','删除成功','info');
		    						$('#add_Contract_Atta_list').datagrid('reload');
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
				{field:'fileName',title:'附件名称',width:80}
			]]
			});
		$('#editWin').window('center');
		$('#editWin').window('open');
	}
	//添加采购订单明细
	function addDetail(){
		$('#addDetailForm').attr('action','<%=request.getContextPath()%>/contract/saveDetail');
		$('#detailId').val(0);
		$('#add_detail_planId').val('');
		$('#viewName').html('');
		$('#viewModel').html('');
		$('#viewBrand').html('');
		$('#viewPurpose').html('');
		$('#addAmount').val('');
		$('#viewUnit').html('');
		$('#addUnitPrice').val('');
		$('#addDSum').val('');
		$('#addRemark').val('');
		$('#addDetailWin').window('center');
		$('#addDetailWin').window('open');
	}
	//编辑采购订单明细
	function editDetail(data){
		$('#addDetailForm').attr('action','<%=request.getContextPath()%>/contract/updateDetail');
		$('#detailId').val(data.id);
		$('#add_detail_planId').val(data.planId);
		$('#add_detail_contractId').val(data.contractId);
		$('#viewName').html(data.name);
		$('#viewModel').html(data.model);
		$('#viewBrand').html(data.brand);
		$('#viewPurpose').html(data.purpose);
		$('#addAmount').val(data.amount);
		$('#viewUnit').html(data.unit);
		$('#addUnitPrice').val(data.unitPrice);
		$('#addDSum').val(data.dSum);
		$('#addRemark').val(data.remark);
		$('#addDetailWin').window('center');
		$('#addDetailWin').window('open');
	}
	//删除采购订单明细
	function deleteDetail(data){
		MaskUtil.mask();
		$.ajax({
			url:"<%=request.getContextPath()%>/contract/deleteDetail?id=" + data.id,
			type:"post",
			dataType:"json",
			success:function(data, textStatus){
				MaskUtil.unmask();
				if(data.flag){
					msgShow('提示','删除成功','info');
					$('#add_ContractDetail_list').datagrid('reload');
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
	//选中采购计划
	function selectPlan(data){
		//设置采购订单明细信息
		$('#add_detail_planId').val(data.id);
		$('#viewName').html(data.name);
		$('#viewModel').html(data.model);
		$('#viewBrand').html(data.brand);
		$('#viewPurpose').html(data.purpose);
		$('#addAmount').val('');
		$('#viewUnit').html(data.unitName);
		$('#addUnitPrice').val('');
		$('#addDSum').val('');
		$('#addRemark').val('');
		
		//清空采购计划明细搜索条件
		$('.plan_queryParam').val('');
		
		//关闭采购计划列表窗口
		$('#planWin').window('close');
	}
	
	//选择物品
	function selectGoods(data){
		//设置入库物品信息
		$('#goodsId').val(data.id);
		$('#viewName').html(data.name);
		$('#viewModel').html(data.model);
		$('#viewUnit').html(data.unitName);
		$('#viewBrand').html(data.brand);
		
		//清空物品库搜索条件
		$('#search-name').val('');
		$('#search-code').val('');
		$('#search-model').val('');
		$('#search-brand').val('');
		
		//关闭物品库窗口
		$('#goodsWin').window('close');
	}
	
	//添加附件
	function addAtta(){
		$('#addAttaWin').window('open');
	}
	//查看采购订单
	function viewContract(data){
		$('#viewWin').window({"title":"查看    采购订单编号:"+data.code});
		$('#view_contractDetail_list').datagrid({
			url: '<%=request.getContextPath()%>/contract/getDetailList?contractId='+data.id,
			title:'采购订单明细',
			editCell:true,
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			columns:[[
				{field:'id',title:'ID',width:80,hidden:true},
				{field:'contractId',title:'采购订单ID',width:80,hidden:true},
				{field:'planId',title:'采购计划ID',width:80,hidden:true},
				{field:'name',title:'名称',width:80},
				{field:'model',title:'规格型号',width:80},
				{field:'brand',title:'品牌',width:80},
				{field:'purpose',title:'用途',width:80},
				{field:'amount',title:'数量',width:80},
				{field:'unit',title:'单位',width:80},
				{field:'unitPrice',title:'单价',width:80},
				{field:'dSum',title:'总金额',width:80},
				{field:'remark',title:'备注',width:80}
			]]
		});
		
		$('#view_contractAtta_list').datagrid({
			url: '<%=request.getContextPath()%>/contract/getContractAttaList?contractId='+data.id,
			title:'附件清单',
			toolbar:[
				{iconCls : 'icon-ok', text : '下载附件', 
					handler: function(){
						var data = $('#view_contractAtta_list').datagrid('getSelected');
						if(data==null){
							 msgShow('提示', '请选中需要下载的附件' , 'warning');
							 return;
						}
						window.open('<%=request.getContextPath()%>/contract/downloadContractAtta?id='+data.id);
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
			url: '<%=request.getContextPath()%>/audit/getAuditList?id='+data.id+'&type=7',
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
		
		$("#view_code").html(data.code);
		$("#view_name").html(data.name);
		$("#view_supplier").html(data.supplier);
		$("#view_supplierLinkman").html(data.supplierLinkman);
		$("#view_supplierPhone").html(data.supplierPhone);
		$("#view_signUser").html(data.signUserName);
		$("#view_signDate").html(data.signDateStr);
		$("#view_sum").html(fmoney(data.sum));
		$("#view_receiveUser").html(data.receiveUserName);
		$("#view_receiveTime").html(data.receiveTimeStr);
		$("#view_remark").html(data.remark);
		$('#view_company').html(data.company);
		
		$('#viewWin').window({"title":"查看   采购订单编号:"+data.code});
		$('#viewWin').window('open');
	}
	//删除采购订单
	function deleteContract(data){
		MaskUtil.mask();
		$.ajax({
			url:"<%=request.getContextPath()%>/contract/deleteContract?id=" + data.id,
			type:"post",
			dataType:"json",
			success:function(data, textStatus){
				MaskUtil.unmask();
				if(data.flag){
					msgShow('提示','删除成功','info');
					$('#contract_list').datagrid('reload');
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
	
	//提交合同
	function submitContract(data){
		MaskUtil.mask();
		$.ajax({
			url:"<%=request.getContextPath()%>/contract/submitContract?id=" + data.id,
			type:"post",
			dataType:"json",
			success:function(data, textStatus){
				MaskUtil.unmask();
				if(data.flag){
					msgShow('提示','提交成功','info');
					$('#contract_list').datagrid('reload');
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
	<!-- 列表及查询 -->
	<table style="width:100%;height:auto;border: 1px solid #ccc; font-size: 12px;color: #888;padding: 5px;">
		<tr style="padding-bottom: 35px;">
			<td style="text-align: right;">
				订单号：
			</td>
			<td style="text-align: left;">
				<input class="queryParam" name="code" style="width: 75%; height: 17px;"/>
			</td>
			<td style="text-align: right;">
				订单名称：
			</td>
			<td style="text-align: left;">
				<input class="queryParam" name="name" style="width: 75%; height: 17px;"/>
			</td>
			<td style="text-align: right;">
				供应商：
			</td>
			<td style="text-align: left;">
				<input class="queryParam" name="supplier" style="width: 75%; height: 17px;"/>
			</td>
			<td style="text-align: right;">
				供应商联系人：
			</td>
			<td style="text-align: left;">
				<input class="queryParam" name="supplierLinkman" style="width: 75%; height: 17px;"/>
			</td>
		</tr>
		<tr style="padding-bottom: 35px;">
			<td style="text-align: right;">
				供应商联系电话：
			</td>
			<td style="text-align: left;">
				<input class="queryParam" name="SUPPLIER_PHONE" style="width: 75%; height: 17px;"/>
			</td>
			<td style="text-align: right;">
				签单人：
			</td>
			<td style="text-align: left;">
				<input class="signUserCombobox" id="signerUser_search_combobox" style="width: 150px; height: 22px;"/>
				<input type="hidden" class="queryParam" name="signuser" id="signerUser_search">
			</td>
			<td style="text-align: right;">
				收货人：
			</td>
			<td style="text-align: left;">
				<input class="receiveUserCombobox" id="receiveUser_search_combobox" style="width: 150px; height: 22px;"/>
				<input type="hidden" class="queryParam" name="receiveUser" id="receiveUser_search">
			</td>
			<td style="text-align: right;">
				状态：
			</td>
			<td style="text-align: left;">
				<input id="search-status" style="width: 150px; height: 23px;"/>
			</td>
		</tr>
		<tr style="padding-bottom: 35px;">
			<td style="text-align: right;">
				签订日期：
			</td>
			<td style="text-align: left;">
				<input class="easyui-datebox" id="signDateBegin" style="width: 155%; height: 23px;"/>
				<input type="hidden" class="queryParam" id="signDateBegin_search" name="signDateBegin"/>
			</td>
			<td style="text-align: left;">
				至
			</td>
			<td style="text-align: left;">
				<input class="easyui-datebox" id="signDateEnd" style="width: 155%; height: 23px;"/>
				<input type="hidden" class="queryParam" id="signDateEnd_search" name="signDateEnd"/>
			</td>
			<td style="text-align: right;">
				到货日期：
			</td>
			<td style="text-align: left;">
				<input class="easyui-datebox" id="receiveTimeBegin" style="width: 155%; height: 23px;"/>
				<input type="hidden" class="queryParam" id="receiveTimeBegin_search" name="receiveTimeBegin"/>
			</td>
			<td style="text-align: left;">
				至
			</td>
			<td style="text-align: left;">
				<input class="easyui-datebox" id="receiveTimeEnd" style="width: 155%; height: 23px;"/>
				<input type="hidden" class="queryParam" id="receiveTimeEnd_search" name="receiveTimeEnd"/>
			</td>
		</tr>
		<tr style="padding-bottom: 35px;">
			<td style="text-align: right;">
				总额：
			</td>
			<td style="text-align: left;">
				<input class="queryParam" name="sumBegin" style="width: 75%; height: 17px;"/>
			</td>
			<td style="text-align: left;">
				至
			</td>
			<td style="text-align: left;">
				<input class="queryParam" name="sumEnd" style="width: 75%; height: 17px;"/>
			</td>
			<td></td><td></td><td></td>
			<td style="text-align: center;" colspan="2">
				<a id="search" class="easyui-linkbutton" style="height: 25px;" iconCls="icon-search">搜索</a>
			</td>
		</tr>
	</table>
	<div style="height: 10px;"></div>
	<table id="contract_list">
	</table>
	<!-- 新增采购订单 -->
	<div id="addWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-add">  
    	<form action="#" method="post" id="addForm">
   			<table style="width: 100%;">
   				<tr style="line-height: 25px;">
    	  			<td style="width: 8%; text-align: right;">订单名称：</td>
    	  			<td style="width: 15%; text-align: left;">
    	  				<input name="name" class="easyui-validatebox" required="true" style="width: 85%;">
                		
    	  			</td>
    	  			<td style="width: 8%; text-align: right;">采购员：</td>
    	  			<td style="width: 8%; text-align: left;">
    	  				<input class="signUserCombobox" id="signUser_add_combobox" style="width: 130px;"/>
    	  				<input type="hidden" name="signUser" id="signUser_add"/>
    	  				
    	  			</td>
    	  			<td style="width: 8%; text-align: right;">总金额(元)：</td>
    	  			<td style="width: 8%; text-align: left;">
    	  				<input name="sum" class="easyui-validatebox" required="true" style="width: 85%;">
                		
    	  			</td>
    	  			<td style="width: 8%; text-align: right;">签订日期：</td>
    	  			<td style="width: 8%; text-align: left;">
    	  				<input name="signDateStr" class="add-datebox"
    	  					style="width: 130px; height: 22px;">
                		
    	  			</td>
    	  		</tr>
    	  		<tr style="line-height: 25px;">
    	  			<td style="text-align: right;">供应商：</td>
    	  			<td style="text-align: left;">
    	  				<input name="supplier" class="easyui-validatebox" required="true" style="width: 85%;">
                		
    	  			</td>
    	  			<td style="text-align: right;">联系人：</td>
    	  			<td style="text-align: left;">
						<input name="supplierLinkman" class="easyui-validatebox" required="true" style="width: 85%;">
                		
					</td>
					<td style="text-align: right;">联系电话：</td>
    	  			<td style="text-align: left;">
						<input name="supplierPhone" class="easyui-validatebox" required="true" style="width: 85%;">
                		
					</td>
    	  			<td style="text-align: right;">到货日期：</td>
    	  			<td style="text-align: left;">
    	  				<input name="receiveTimeStr" class="add-datebox"
    	  					style="width: 130px; height: 22px;">
    	  			</td>
    	  		</tr>
    	  		<tr>
    	  			<td style="width: 8%; text-align: right;">收货人：</td>
    	  			<td style="width: 8%; text-align: left;">
    	  				<!--
    	  				<input class="receiveUserCombobox" id="receiveUser_add_combobox" style="width: 130px;"/>
    	  				<input type="hidden" name="receiveUser" id="receiveUser_add"/>
    	  				-->
    	  				<input id="addReceiveUserName" name="receiveUserName" style="width: 200px;"/>
    	  			</td>
    	  			<td style="text-align: right;">采购单位：</td>
    	  			<td style="text-align: left;">
    	  				<input id="buy_company" style="width: 130px;"/>
    	  				<input type="hidden" name="company" id="add_company">
					</td>
    	  			<td style="text-align: right;"></td>
    	  			<td style="text-align: left;">
    	  			</td>
    	  			<td style="text-align: right;"></td>
    	  			<td style="text-align: left;">
    	  			</td>
    	  		</tr>
    	  		<tr style="line-height: 25px;">
    	  			<td style="text-align: right;">备注：</td>
    	  			<td style="text-align: left;" colspan="9">
    	  				<textarea name="remark" style="width:600px; height:80px; margin:5px;"></textarea>
    	  			</td>
    	  		</tr>
    	  	</table>
    	  	<div style="height: 10px;"></div>
    	  	<table style="width: 100%;">
    	  		<tr>
    	  			<td style="text-align: center;">
    	  				<a id="add-save" class="easyui-linkbutton" iconCls="icon-save">保存</a>
    	  			</td>
    	  		</tr>
    		</table>
    	</form>
  	</div>
  	<!-- 编辑采购订单 -->
	<div id="editWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-add">  
    	<form action="#" method="post" id="editForm">
    		<input type="hidden" name="id"/>
   			<table style="width: 100%;">
   				<tr style="line-height: 25px;">
    	  			<td style="width: 8%; text-align: right;">订单名称：</td>
    	  			<td style="width: 15%; text-align: left;">
    	  				<input name="name" class="easyui-validatebox" required="true" style="width: 85%;">
                		
    	  			</td>
    	  			<td style="width: 8%; text-align: right;">采购员：</td>
    	  			<td style="width: 8%; text-align: left;">
    	  				<input class="signUserCombobox" id="signUser_edit_combobox" style="width: 130px;"/>
    	  				<input type="hidden" name="signUser" id="signUser_edit"/>
    	  				
    	  			</td>
    	  			<td style="width: 8%; text-align: right;">总金额(元)：</td>
    	  			<td style="width: 8%; text-align: left;">
    	  				<input name="sum" class="easyui-validatebox" required="true" style="width: 85%;">
                		
    	  			</td>
    	  			<td style="width: 8%; text-align: right;">签订日期：</td>
    	  			<td style="width: 8%; text-align: left;">
    	  				<input name="signDateStr" class="datebox"
    	  					style="width: 130px; height: 22px;">
                		
    	  			</td>
    	  		</tr>
    	  		<tr style="line-height: 25px;">
    	  			<td style="text-align: right;">供应商：</td>
    	  			<td style="text-align: left;">
    	  				<input name="supplier" class="easyui-validatebox" required="true" style="width: 85%;">
                		
    	  			</td>
    	  			<td style="text-align: right;">联系人：</td>
    	  			<td style="text-align: left;">
						<input name="supplierLinkman" class="easyui-validatebox" required="true" style="width: 85%;">
                		
					</td>
					<td style="text-align: right;">联系电话：</td>
    	  			<td style="text-align: left;">
						<input name="supplierPhone" class="easyui-validatebox" required="true" style="width: 85%;">
                		
					</td>
    	  			<td style="text-align: right;">到货日期：</td>
    	  			<td style="text-align: left;">
    	  				<input name="receiveTimeStr" class="datebox"
    	  					style="width: 130px; height: 22px;">
                		
    	  			</td>
    	  		</tr>
    	  		<tr style="line-height: 25px;">
    	  			<td style="width: 8%; text-align: right;">收货人：</td>
    	  			<td style="width: 8%; text-align: left;">
    	  				<!--
    	  				<input class="receiveUserCombobox" id="receiveUser_edit_combobox" style="width: 130px;"/>
    	  				<input type="hidden" name="receiveUser" id="receiveUser_edit"/>
    	  				-->
    	  				<input id="edit_receiveUserName" name="receiveUserName" style="width: 200px;"/>
    	  			</td>
    	  			<td style="text-align: right;">采购单位：</td>
    	  			<td style="text-align: left;" id="edit_company">
    	  			
					</td>
    	  			<td style="text-align: right;"></td>
    	  			<td style="text-align: left;">
    	  			</td>
    	  			<td style="text-align: right;"></td>
    	  			<td style="text-align: left;">
    	  			</td>
    	  		</tr>
    	  		<tr style="line-height: 25px;">
    	  			<td style="text-align: right;">备注：</td>
    	  			<td style="text-align: left;" colspan="9">
    	  				<textarea name="remark" style="width:600px; height:80px; margin:5px;"></textarea>
    	  			</td>
    	  		</tr>
    	  	</table>
    	  	<div style="height: 10px;"></div>
    	  	<table id="add_ContractDetail_list"></table>
    	  	<div style="height: 10px;"></div>
    	  	<table id="add_Contract_Atta_list"></table>
    	  	<div style="height: 10px;"></div>
    	  	<table style="width: 100%;">
    	  		<tr>
    	  			<td style="text-align: center;">
    	  				<a id="edit-save" class="easyui-linkbutton" iconCls="icon-save">保存</a>
    	  			</td>
    	  		</tr>
    		</table>
    	</form>
  	</div>
  	<!-- 新增采购订单明细 -->
  	<div id="addDetailWin" class="easyui-window" collapsible="false"
		minimizable="false" maximizable="false" iconCls="icon-add">
		<div align="center" style="margin: 20px;">
			<form action="#" method="post" id="addDetailForm">
				<table width="310" border="0" align="center">
					<input type="hidden" name="contractId" id="add_detail_contractId"/>
					<input type="hidden" name="id" id="detailId"/>
					<input type="hidden" name="planId" id="add_detail_planId"/>
					<input type="hidden" name="goodsId" id="goodsId"/>
					<tr>
						<!--
						<td colspan="2">
							<a class="easyui-linkbutton" iconCls="icon-add" id="choose-plan">选择采购计划</a>
						</td>
						-->
						<td colspan="2">
							<a class="easyui-linkbutton" iconCls="icon-add" id="choose-goods">选择物品</a>
						</td>
					</tr>
					
					<tr style="line-height: 30px;">
						<td width="110">产品名称：</td>
						<td id="viewName"></td>
					</tr>
					<tr style="line-height: 30px;">
						<td>规格型号：</td>
						<td id="viewModel"></td>
					</tr>
					<tr style="line-height: 30px;">
						<td>品牌：</td>
						<td id="viewBrand"></td>
					</tr>
					<!--
					<tr style="line-height: 30px;">
						<td>用途：</td>
						<td id="viewPurpose"></td>
					</tr>
					-->
					<tr>
						<td>数量：</td>
						<td>
							<input name="amount" class="easyui-validatebox" required="true"
								validType="nums" id="addAmount" style="width: 200px;">
						</td>
					</tr>
					<tr style="line-height: 30px;">
						<td>单位：</td>
						<td id="viewUnit"></td>
					</tr>
					<tr>
						<td>单价：</td>
						<td>
							<input class="easyui-validatebox" required="true"
								name="unitPrice" id="addUnitPrice" validType="nums" style="width: 200px;">
						</td>
					</tr>
					<tr>
						<td>总金额：</td>
						<td>
							<input class="easyui-validatebox" required="true"
								name="dSum" id="addDSum" validType="nums" style="width: 200px;">
						</td>
					</tr>
					<tr>
						<td>备注：</td>
						<td>
							<textarea name="remark" id="addRemark" style="width: 200px; height: 60px; margin: 5px;"></textarea>
						</td>
					</tr>

					<tr>
						<td style="text-align: center;" colspan="2">
							<a class="easyui-linkbutton" iconCls="icon-save" id="addDetail-save">保存</a>
						</td>
					</tr>
				</table>
			</form>
		</div>
	</div>
	<!-- 采购计划明细列表 -->
	<div id="planWin" class="easyui-window" collapsible="false"
		minimizable="false" maximizable="false" iconCls="icon-search" style="position: relative;">  
    	<table style="width:100%;height:auto;border: 1px solid #ccc; font-size: 12px;color: #888;padding: 5px;">
		<tr style="padding-bottom: 35px;">
			<td style="text-align: right;">
				采购编号：
			</td>
			<td style="text-align: left;">
				<input class="plan_queryParam" name="code" style="width: 75%; height: 17px;"/>
			</td>
			<td style="text-align: right;">
				计划人：
			</td>
			<td style="text-align: left;">
				<input id="search_applyUser_name" style="width: 150px; height: 22px;"/>
				<input type="hidden" class="plan_queryParam" name="applyUser" id="search_applyUser_code">
			</td>
			<td style="text-align: right;">
				计划日期：
			</td>
			<td style="text-align: left;">
				<input class="easyui-datebox" id="applyDateBegin" style="width: 155%; height: 23px;"/>
				<input type="hidden" class="plan_queryParam" id="search_applyDateBegin" name="applyDateBegin"/>
			</td>
			<td style="text-align: left;">
				至
			</td>
			<td style="text-align: left;">
				<input class="easyui-datebox" id="applyDateEnd" style="width: 155%; height: 23px;"/>
				<input type="hidden" class="plan_queryParam" id="search_applyDateEnd" name="applyDateEnd"/>
			</td>
		</tr>
		<tr style="padding-bottom: 35px;">
			<td style="text-align: right;">
				物品名称：
			</td>
			<td style="text-align: left;">
				<input class="plan_queryParam" name="name" style="width: 75%; height: 17px;"/>
			</td>
			<td style="text-align: right;">
				规格型号：
			</td>
			<td style="text-align: left;">
				<input class="plan_queryParam" name="model" style="width: 75%; height: 17px;"/>
			</td>
			<td style="text-align: right;">
				品牌：
			</td>
			<td style="text-align: left;">
				<input class="plan_queryParam" name="brand" style="width: 75%; height: 17px;"/>
			</td>
			<td style="text-align: center;" colspan="2">
				<a id="plan_search" class="easyui-linkbutton" style="height: 25px;" iconCls="icon-search">搜索</a>
			</td>
		</tr>
	</table>
	<div style="height: 10px;"></div>
	<table id="plan_list"></table>
  	</div>
  	<!-- 新增采购订单附件信息 -->
  	<div id="addAttaWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-add">
        <div style="height: 40px;"></div>
        <form action="#" id="attaForm" method="post" enctype="multipart/form-data">
        	<input type="hidden" id="atta_contractId" name="contractId"/>
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
    <!-- 查看采购订单 -->
    <div id="viewWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-search">  
    	  <table style="width: 100%;">
   				<tr style="line-height: 25px;">
   					<td style="width: 8%; text-align: right;">订单号：</td>
    	  			<td style="width: 15%; text-align: left;" id="view_code">
    	  			</td>
    	  			<td style="width: 8%; text-align: right;">订单名称：</td>
    	  			<td style="width: 15%; text-align: left;" id="view_name">
    	  			</td>
    	  			<td style="width: 8%; text-align: right;">签单人：</td>
    	  			<td style="width: 8%; text-align: left;" id="view_signUser">
    	  			</td>
    	  			<td style="width: 8%; text-align: right;">总金额(元)：</td>
    	  			<td style="width: 8%; text-align: left;" id="view_sum">
    	  			</td>
    	  		</tr>
    	  		<tr style="line-height: 25px;">
    	  			<td style="width: 8%; text-align: right;">签订日期：</td>
    	  			<td style="width: 8%; text-align: left;" id="view_signDate">
    	  			</td>
    	  			<td style="text-align: right;">供应商：</td>
    	  			<td style="text-align: left;" id="view_supplier">
    	  			</td>
    	  			<td style="text-align: right;">联系人：</td>
    	  			<td style="text-align: left;" id="view_supplierLinkman">
					</td>
					<td style="text-align: right;">联系电话：</td>
    	  			<td style="text-align: left;" id="view_supplierPhone">
					</td>
				</tr>
    	  		<tr style="line-height: 25px;">
    	  			<td style="text-align: right;">到货日期：</td>
    	  			<td style="text-align: left;" id="view_receiveTime">
    	  			</td>
    	  			<td style="width: 8%; text-align: right;">收货人：</td>
    	  			<td style="width: 8%; text-align: left;" id="view_receiveUser">
    	  			</td>
    	  			<td style="text-align: right;">采购单位：</td>
    	  			<td style="text-align: left;" id="view_company">
					</td>
    	  			<td style="text-align: right;"></td>
    	  			<td style="text-align: left;">
    	  			</td>
    	  		</tr>
    	  		<tr style="line-height: 25px;">
    	  			<td style="text-align: right;">备注：</td>
    	  			<td style="text-align: left;" colspan="8" id="view_remark">
    	  			</td>
    	  		</tr>
    	  	</table>
    	  
    	  <table id="view_contractDetail_list"></table>
    	  
    	  	<div style="height: 10px;"></div>
    	  
    	  	<table id="view_contractAtta_list"></table>
    	  	
    	  	<div style="height: 10px;"></div>
    	  
    	  <table id="viewAuditLogList"></table>
    	  
  	</div>
  	
  	<div id="goodsWin" class="easyui-window" collapsible="false"
		minimizable="false" maximizable="false" iconCls="icon-search" style="position: relative;">
		
		<div style="width:180px;height:520px; position: absolute; left: 0; top: 0;border-right: 1px solid #ccc;">
			<div style="height: 20px;"></div>
      		<ul id="tt" class="easyui-tree"></ul>
    	</div>
    	
    	<div style="position: absolute;left: 180px; top: 0; width: 685px;height: 520px;">
			<table style="width: 100%; height: auto; border-bottom: 1px solid #ccc;border-right: 1px solid #ccc; font-size: 12px; color: #888; padding: 5px;">
				<tr style="line-height: 30px;">
					<td style="text-align: right;">名称：</td>
					<td style="text-align: left;">
						<input style="width: 75%; height: 17px;" class="goods_queryParam" id="search-name" name="name"/>
					</td>
					<td style="text-align: right;">编码：</td>
					<td style="text-align: left;">
						<input style="width: 75%; height: 17px;" class="goods_queryParam" id="search-code" name="code"/>
					</td>
					<td style="text-align: right;"></td>
					<td style="text-align: left;"></td>
				</tr>
				<tr>
					<td style="text-align: right;">规格：</td>
					<td style="text-align: left;">
						<input style="width: 75%; height: 17px;" class="goods_queryParam" id="search-model" name="model"/>
					</td>
					<td style="text-align: right;">品牌：</td>
					<td style="text-align: left;">
						<input style="width: 75%; height: 17px;" class="goods_queryParam" id="search-brand" name="brand"/>
					</td>
					<td style="text-align: center;" colspan="2">
						<a id="goods-search" class="easyui-linkbutton" style="height: 25px;" iconCls="icon-search">搜索</a>
					</td>
				</tr>
			</table>
			<table id="goodsList"></table>
		</div>
	</div>
</body>
</html>