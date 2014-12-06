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
		//$(".datebox :text").attr("readonly","readonly");
		$('.datebox').datebox({
			editable:false
		});
		
		$('#procurement_list').datagrid({
			url: '<%=request.getContextPath()%>/procurementPlan/getProcurementPlanList',
			toolbar:[{iconCls : 'icon-add', text : '新增', 
						handler: function(){
							addPlan();
						}
					},
					{iconCls : 'icon-edit', text : '编辑', 
						handler: function(){
							var data = $('#procurement_list').datagrid('getSelected');
							if(data==null){
						 		msgShow('提示', '请选中需要编辑的数据' , 'warning');
						 		return;
						 	}
							if(data.status == 0 || data.status == -5555){
								editPlan(data);		
							}else{
								msgShow('提示', '只能编辑未提交或退回的记录' , 'warning');
							}
							
						}
					},
					{iconCls : 'icon-search', text : '查看', 
						handler: function(){
							var data = $('#procurement_list').datagrid('getSelected');
							if(data==null){
						 		msgShow('提示', '请选中需要查看的数据' , 'warning');
						 		return;
						 	}
							
							viewPlan(data);
						}
					},
					{iconCls : 'icon-ok', text : '提交', 
						handler: function(){
							var data = $('#procurement_list').datagrid('getSelected');
							if(data==null){
						 		msgShow('提示', '请选中需要提交的数据' , 'warning');
						 		return;
						 	}
							
							if(data.status == 0 || data.status == -5555){
								submitPlan(data);	
							}else{
								msgShow('提示', '只能提交未提交或退回的记录' , 'warning');
							}
						}
					},
					{iconCls : 'icon-remove', text : '删除', 
						handler: function(){
							var data = $('#procurement_list').datagrid('getSelected');
							if(data==null){
						 		msgShow('提示', '请选中需要删除的数据' , 'warning');
						 		return;
						 	}
							
							if(data.status == 0 || data.status == -5555){
								deletePlan(data);
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
//				{field:'remark',title:'备注',width:80},
//				{field:'status',title:'状态',width:80},
				/* {field:'id',title:'操作',width:120, formatter:function(value, rowData, rowIndex){
					return '<a href="javascript:viewPlan();">查看</a>&nbsp;&nbsp;'
						+ '<a href="#;">提交</a>&nbsp;&nbsp;'
						+ '<a href="#">删除</a>&nbsp;&nbsp;';
				}} */
			]],
			onDblClickRow:function(rowIndex, rowData) {  
				viewPlan(rowData); 
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
		
		
		$('#addWin').window({
            title: '新增采购计划',
            width: 1000,
            modal: true,
            shadow: true,
            closed: true,
            height: 100,
            top:0,
            left:50
        });
		
		$('#editWin').window({
            title: '编辑采购计划',
            width: 1000,
            modal: true,
            shadow: true,
            closed: true,
            height: 550,
            top:0,
            left:50
        });
		
	/* 	$('#addProcurementDetailWin').window({
			title: '添加物品',
			width: 1000,
			modal: true,
            shadow: true,
            closed: true,
            height: 550,
            top:0,
            left:0
		}); */
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
		
		$('#addForm').form({
			url:'<%=request.getContextPath()%>/procurementPlan/saveProcurementPlan',
			onSubmit:function(){
				//$('#add_applyUser_code').val($('#add_applyUser_name').combobox('getValue'));
				return $(this).form('validate');
			},
			success:function(data){
				var data = eval('(' + data + ')');
				if(data.flag){
					$('#addWin').window('close');
					$('#procurement_list').datagrid('reload');
					editPlan(data.data);
				}else{
					msgShow('提示','保存失败','error');
				}
			}
		});
		
		$('#add-save').on('click', function(){
			$('#addForm').submit();
		});
		
		$('#editForm').form({
			url:'<%=request.getContextPath()%>/procurementPlan/updateProcurementPlan',
			onSubmit:function(){
				//$('#edit_applyUser_code').val($('#edit_applyUser_name').combobox('getValue'));
				return $(this).form('validate');
			},
			success:function(data){
				var data = eval('(' + data + ')');
				if(data.flag){
					msgShow('提示','保存成功','info');
					$('#procurement_list').datagrid('reload');
					$('#editWin').window('close');
				}else{
					msgShow('提示','保存失败','error');
				}
			}
		});
		
		$('#edit-save').on('click', function(){
			$('#editForm').submit();
		});
		
		<%-- $('#procurementDetailForm').form({
			url:'<%=request.getContextPath()%>/procurementPlan/saveProcurementDetail',
			onSubmit:function(){
				$('#unitId').val($('#add_unit').combobox('getValue'));
				return $(this).form('validate');
			},
			success:function(data){
				var data = eval('(' + data + ')');
				if(data.flag){
					msgShow('提示','保存成功','info');
					$('#add_procurementDetail_List').datagrid('reload');
					$('#addProcurementDetailWin').window('close');
				}else{
					msgShow('提示','保存失败','error');
				}
			}
		});
		
		$('#procurementDetail_save').on('click', function(){
			$('#procurementDetailForm').submit();
		});
		 --%>
		 
		$('#search-status').combobox({
				data:[{'id':'-1', 'text':'全部'},{'id':-5555,'text':'退回'},
				      {'id':0,'text':'未提交'},{'id':10,'text':'销售部审批中'},{'id':20,'text':'财务部审批中'},
				      {'id':30,'text':'已生效'}
				     ],
				valueField:'id',
				textField:'text',
				editable:false
			});
			
		$('#search-status').combobox('select', -1);
		
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
				queryParams.status = status;	
			}
			
			$('#procurement_list').datagrid('options').queryParams = queryParams;
			$('#procurement_list').datagrid('reload');
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
		
		$('#add-receiver').combobox({
			url:'<%=request.getContextPath()%>/user/getUsersByRole?roleCode=CKGLY',
			valueField:'id',
			textField:'text',
			required:true,
			editable:false
		});
		
		//加载单位
		$('#goods-unit').combobox({
			url:'<%=request.getContextPath()%>/sys/getAllUnit',
			valueField:'id',
			textField:'name',
			editable:false,
			required:true
		});
		
		$('#add-goods-reload').on('click', function(){
			$('#goods-unit').combobox('reload');
		});
		
		
		//搜索物品库
		$('#goods-search').on('click', function(){
			var queryParams = {};
			var params = $('.goods_queryParam');
			for(i=0;i<params.length;i++){
				if($(params[i]).val() != ''){
					queryParams[$(params[i]).attr('name')] = $(params[i]).val();
				}
			}
			
			$('#goodsList').datagrid('options').queryParams = queryParams;
			$('#goodsList').datagrid('reload');
		});
		//---------------------我是分隔线------------------------------
		
		$('#addInEntrepotWin').window({
			title: '新增物品',
			width: 500,
			modal: true,
            shadow: true,
            closed: true,
            height: 550,
            top:0,
            left:200
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
		
		$('#addGoodsWin').window({
			title: '新增物品',
			width: 500,
			modal: true,
            shadow: true,
            closed: true,
            height: 560,
            top:0,
            left:100
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
		
		//新增物品
		$('#addGoodsForm').form({
			url:'<%=request.getContextPath()%>/sys/addGoods',
			onSubmit:function(){
				$('#addGoodsUnit').val($('#goods-unit').combobox('getValue'));
				if($(this).form('validate')){
					MaskUtil.mask();
				}
				return $(this).form('validate');
			},
			success:function(data){
				var data = eval('(' + data + ')');
				if(data.flag){
					msgShow('提示','保存成功','info');
					$('#addGoodsWin').window('close');
					$('#goodsList').datagrid('reload');
					$(this).form('reset');
				}else{
					msgShow('提示',data.msg,'error');
				}
			}
		});
		
		$('#add-goods-save').on('click', function(){
			$('#addGoodsForm').submit();
		});
		
		//-------------------------------------点击的一下function函数并发送请求---------------------------
		//新增
		$('#addProductForm').form({
			onSubmit:function(){
				return $(this).form('validate');
			},
			success:function(data){
				var data = eval('(' + data + ')');
				if(data.flag){
					msgShow('提示','保存成功','info');
					$('#addInEntrepotWin').window('close');
					$('#add_procurementDetail_List').datagrid('reload');
					//editPlan(data.data);
				}else{
					msgShow('提示','保存失败','error');
				}
			},
			error:function(){
   				msgShow('提示','保存失败','error');
   			}
		});
		
		$('#addProduct-save').on('click', function(){
			$('#addProductForm').submit();
		});
		$('#attaForm').form({
			url:'<%=request.getContextPath()%>/procurementPlan/addAtta',
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
					$('#addPlanAtta').datagrid('reload');
					$('#addAttaWin').window('close');
				}else{
					msgShow('提示','上传失败','error');
				}
			}
		});
		
		$('#atta_upload').on('click', function(){
			$('#attaForm').submit();
		});
		
	});
	//新增产品
	function addInEntrepot(){
		$('#addProductForm').attr('action','<%=request.getContextPath()%>/procurementPlan/saveProcurementDetail');
		$('#detailId').val(0);
		$('#goodsId').val('');
		$('#goodsName').html('');
		$('#goodsModel').html('');
		$('#goodsUnit').html('');
		$('#goodsBrand').html('');
		$('#pro_purpose').val('');
		$('#pro_amount').val('');
		$('#pro_budgetSum').val('');
		$('#pro_expectArrivalDate').datebox('setValue','');
		$('#pro_remark').val('');
		$('#addInEntrepotWin').window('open');
	}
	//编辑产品
	function editInEntrepot(data){
		$('#addProductForm').attr('action','<%=request.getContextPath()%>/procurementPlan/updateProcurementDetail');
		$('#addInEntrepotWin').window({"title":"编辑物品"});
		$('#detailId').val(data.id);
		$('#add_detail_planId').val(data.planId);
		$('#goodsId').val(data.goodsId);
		$('#goodsName').html(data.name);
		$('#goodsModel').html(data.model);
		$('#goodsUnit').html(data.unitName);
		$('#goodsBrand').html(data.brand);
		$('#pro_purpose').val(data.purpose);
		$('#pro_amount').val(data.amount);
		$('#pro_budgetSum').val(data.budgetSum);
		$('#pro_expectArrivalDate').datebox('setValue',data.expectArrivalDate);
		$('#pro_remark').val(data.remark);
		$('#addInEntrepotWin').window('open');
	}
	//删除计划
	function deletePlan(data){
		MaskUtil.mask();
		$.ajax({
			url:"<%=request.getContextPath()%>/procurementPlan/deleteProcurementPlan?id=" + data.id,
			type:"post",
			dataType:"json",
			success:function(data, textStatus){
				MaskUtil.unmask();
				if(data.flag){
					msgShow('提示','删除成功','info');
					$('#procurement_list').datagrid('reload');
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
	//删除产品
	function deleteInEntrepot(data){
		MaskUtil.mask();
		$.ajax({
			url:"<%=request.getContextPath()%>/procurementPlan/deleteProcurementDetail?id=" + data.id,
			type:"post",
			dataType:"json",
			success:function(data, textStatus){
				MaskUtil.unmask();
				if(data.flag){
					msgShow('提示','删除成功','info');
					$('#add_procurementDetail_List').datagrid('reload');
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
	//选择物品
	function selectGoods(data){
		//设置入库物品信息
		$('#goodsId').val(data.id);
		$('#goodsName').html(data.name);
		$('#goodsModel').html(data.model);
		$('#goodsUnit').html(data.unitName);
		$('#goodsBrand').html(data.brand);
		
		//清空物品库搜索条件
		$('#search-name').val('');
		$('#search-code').val('');
		$('#search-model').val('');
		$('#search-brand').val('');
		
		//关闭物品库窗口
		$('#goodsWin').window('close');
	}
	
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
	
	//新增采购计划
	function addPlan(){
		$('#addWin').window('center');
		$('#addWin').window('open');
	}
	
	
	//编辑采购计划
	function editPlan(data){
		$('#editWin').window({"title":"编辑    采购计划编号:"+data.code});
		
		$('#add_detail_planId').val(data.id);
		$("#atta_planId").val(data.id);
		//$('#atta_orderId').val(data.id);
		
		$('#editForm').form('load', data);
		//$('#edit_applyUser_name').combobox('select', data.applyUser);
		$('#edit_applyUser_name').val(data.applyUserName);
		$('#add_procurementDetail_List').datagrid({
			url: '<%=request.getContextPath()%>/procurementPlan/getProcurementDetailList?planId='+data.id,
			title:'采购计划明细',
			toolbar:[{iconCls : 'icon-add', text : '添加明细', 
				handler: function(){
					addInEntrepot();
				}
			},{iconCls : 'icon-edit', text : '编辑', 
				handler: function(){
					var data = $('#add_procurementDetail_List').datagrid('getSelected');
					if(data==null){
				 		msgShow('提示', '请选中需要编辑的数据' , 'warning');
				 		return;
				 	}
					editInEntrepot(data);	
				}
			},{iconCls : 'icon-remove', text : '删除', 
				handler: function(){
					var data = $('#add_procurementDetail_List').datagrid('getSelected');
					if(data==null){
				 		msgShow('提示', '请选中需要删除的数据' , 'warning');
				 		return;
				 	}
					
					if(data.status == 0 || data.status == -5555){
						deleteInEntrepot(data);	
					}else{
						msgShow('提示', '只能删除未提交或退回的订单' , 'warning');
					}
				}
			}],
			editCell:true,
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
				{field:'budgetSum',title:'预算金额',width:80, align:'right', 
					formatter:function(value, rowData, rowIndex){
						return fmoney(value);
					}
				},
				{field:'expectArrivalDate',title:'期望到货日期',width:80},
				{field:'remark',title:'备注',width:80}
			]]
		});
		
		/*var productPage = $('#add_procurementDetail_List').datagrid('getPager'); 
		productPage.pagination({  
	        pageSize : 10,// 每页显示的记录条数，默认为20  
	        pageList : [10],// 可以设置每页记录条数的列表  
	        beforePageText : '第',// 页数文本框前显示的汉字  
	        afterPageText : '页    共 {pages} 页',  
	        displayMsg : '当前显示 {from} - {to} 条记录   共 {total} 条记录'   
	    });*/
		
		$('#addPlanAtta').datagrid({
			url: '<%=request.getContextPath()%>/procurementPlan/getProcurementPlanAttaList?planId='+data.id,
			title:'附件清单',
			toolbar:[
			    {iconCls : 'icon-add', text : '添加附件', 
					handler: function(){
						addAtta(); 
					}
				},
				{iconCls : 'icon-ok', text : '下载附件', 
					handler: function(){
						var data = $('#addPlanAtta').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要下载的附件' , 'warning');
					 		return;
					 	}
						window.open('<%=request.getContextPath()%>/procurementPlan/downloadProcurementPlanAtta?attaId='+data.id);
					}
				},
				{iconCls : 'icon-remove', text : '删除附件', 
					handler: function(){
						var data = $('#addPlanAtta').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要删除的附件' , 'warning');
					 		return;
					 	}
						MaskUtil.mask();
						$.ajax({
		        			url:"<%=request.getContextPath()%>/procurementPlan/deleteProcurementPlanAtta?attaId=" + data.id,
		    				type:"post",
		    				dataType:"json",
		    				success:function(data, textStatus){
		    					MaskUtil.unmask();
		    					if(data.flag){
		    						msgShow('提示','删除成功','info');
		    						$('#addPlanAtta').datagrid('reload');
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
	 
	
	<%-- //添加采购物品
	function addProcurementDetail(){
		$('#add_unit').combobox({
			url:'<%=request.getContextPath()%>/sys/getAllUnit',
			valueField:'id',
			textField:'name',
			editable:false,
			required:true
		});
		
		$('#procurementDetailList').datagrid({
    		url:'<%=request.getContextPath()%>/procurementPlan/addProcurementDetailList',
			fitColumns: true,
			striped: true,
			singleSelect:false,
			rownumbers:true,
			columns:[[
			    {field:'id', checkbox:true},
				{field:'name',title:'名称',width:80},
				{field:'model',title:'规格型号',width:80},
				{field:'brand',title:'品牌',width:80},
				{field:'unit',title:'单位',width:80}
			]]    
		});
		$('#addProcurementDetailWin').window('open');
	} --%>
	
	
	
	//添加附件
	function addAtta(){
		$('#addAttaWin').window('open');
	}
	
	//提交采购计划
	function submitPlan(data){
		MaskUtil.mask();
		$.ajax({
			url:"<%=request.getContextPath()%>/procurementPlan/submitPlan?id=" + data.id,
			type:"post",
			dataType:"json",
			success:function(data, textStatus){
				MaskUtil.unmask();
				if(data.flag){
					msgShow('提示','提交成功','info');
					$('#procurement_list').datagrid('reload');
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
			<!-- <td style="text-align: right;">
				状态：
			</td>
			<td style="text-align: left;">
				<input style="width: 75%; height: 17px;"/>
			</td>
		</tr>
		<tr> -->
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
  	
  	<div id="addWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-add">  
    	<form action="#" method="post" id="addForm">
   			<table style="width: 100%;">
    	  		<tr style="line-height: 25px;">
    	  			<td style="width: 8%; text-align: right;">计划人：</td>
    	  			<td style="width: 15%; text-align: left;">
    	  				<!--
    	  				<input class="applyUser" id="add_applyUser_name" style="width: 130px;"/>
    	  				<input type="hidden" name="applyUser" id="add_applyUser_code"/>
    	  				-->
    	  				<input id="add_applyUser" name="applyUserName" style="width: 130px;"/>
    	  				<font>*</font>
    	  			</td>
    	  		
    	  			<td style="width: 8%; text-align: right;">计划日期：</td>
    	  			<td style="width: 15%; text-align: left;">
    	  				<input class="add-datebox" name="applyDate" style="width: 180px;">
                		<font>*</font>
    	  			</td>
    	  		</tr>
    	  		<!-- <tr style="line-height: 25px;">
    	  			<td style="text-align: right;">备注：</td>
    	  			<td style="text-align: left;" colspan="9">
    	  				<textarea style="width:600px; height:40px; margin:5px;"></textarea>
    	  			</td>
    	  		</tr> -->
    	  	</table>
    	  
    	  	<!-- <table id="add_procurementDetail_List"></table>
    	  
    	  	<div style="height: 10px;"></div>
    	  
    	  	<table id="addPlanAtta"></table>
    	   -->
    	  	<table style="width: 100%;">
    	  		<tr>
    	  			<td style="text-align: center;">
    	  				<a id="add-save" class="easyui-linkbutton" iconCls="icon-save">保存</a>
                		<!-- <a id="submit" class="easyui-linkbutton" iconCls="icon-ok">提交</a> -->
    	  			</td>
    	  		</tr>
    		</table>
    	</form>
  	</div>
  	<div id="editWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-add">  
    	<form action="#" id="editForm" method="post">
    		<input type="hidden" name="id"/>
   			<table style="width: 100%;">
    	  		<tr style="line-height: 25px;">
    	  			<td style="width: 8%; text-align: right;">计划人：</td>
    	  			<td style="width: 15%; text-align: left;">
    	  				<!--
    	  				<input class="applyUser" id="edit_applyUser_name" style="width: 130px;"/>
    	  				<input type="hidden" name="applyUser" id="edit_applyUser_code"/>
    	  				-->
    	  				<input id="edit_applyUser_name" name="applyUserName" style="width: 130px;"/>
    	  				<font>*</font>
    	  			</td>
    	  		
    	  			<td style="width: 8%; text-align: right;">计划日期：</td>
    	  			<td style="width: 15%; text-align: left;">
    	  				<input class="add-datebox" name="applyDate" style="width: 180px;">
                		<font>*</font>
    	  			</td>
    	  		</tr>
    	  		<!-- <tr style="line-height: 25px;">
    	  			<td style="text-align: right;">备注：</td>
    	  			<td style="text-align: left;" colspan="9">
    	  				<textarea style="width:600px; height:40px; margin:5px;"></textarea>
    	  			</td>
    	  		</tr> -->
    	  	</table>
    	  
    	  	<table id="add_procurementDetail_List"></table>
    	  
    	  	<div style="height: 10px;"></div>
    	  
    	  	<table id="addPlanAtta"></table>
    	  
    	  	<table style="width: 100%;">
    	  		<tr>
    	  			<td style="text-align: center;">
    	  				<a id="edit-save" class="easyui-linkbutton" iconCls="icon-save">保存</a>
                		<!-- <a id="submit" class="easyui-linkbutton" iconCls="icon-ok">提交</a> -->
    	  			</td>
    	  		</tr>
    		</table>
    	</form>
  	</div>
  	<!-- <div id="addProcurementDetailWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-add">
  		<h1 align="center" style="color:#15428B;">添加物品</h1>
       	<div align="center" style="margin:20px;">
       		<form name="procurementDetailForm" id="procurementDetailForm" method="post">
       			<input type="hidden" id="add_detail_planId" name="planId"/>
       			<table id="procurementDetailList"></table>
           		<table width="350" border="0"  align="center" >
           		
           			<tr>
               			<td width="100">名称：</td>
               			<td>
               				<input name="name" class="easyui-validatebox" required="true" style="width: 200px;">
               				<font>*</font>
               			</td>
           			</tr>
           			<tr>
               			<td>规格型号：</td>
               			<td>
               				<input name="model" class="easyui-validatebox" required="true" style="width: 200px;">
               				<font>*</font>
               			</td>
           			</tr>
           			<tr>
               			<td>品牌：</td>
               			<td>
               				<input name="brand" class="easyui-validatebox" required="true" style="width: 200px;">
               				<font>*</font>
               			</td>
           			</tr>
           			<tr>
               			<td>用途：</td>
               			<td>
               				<input name="purpose" class="easyui-validatebox" required="true" style="width: 200px;">
               				<font>*</font>
               			</td>
           			</tr>
           			<tr>
               			<td>数量：</td>
               			<td>
               				<input name="amount" class="easyui-validatebox" required="true" style="width: 200px;">
               				<font>*</font>
               			</td>
           			</tr>
           			<tr>
               			<td>单位：</td>
               			<td>
               				<input id="add_unit" style="width: 200px;">
               				<input type="hidden" id="unitId" name="unitId">
               				<font>*</font>
               			</td>
           			</tr>
           			<tr>
               			<td>单价：</td>
               			<td>
               				<input name="unitPrice" class="easyui-validatebox" required="true" style="width: 200px;">
               				<font>*</font>
               			</td>
           			</tr>
           			<tr>
               			<td>预算金额：</td>
               			<td>
               				<input name="budgetSum" class="easyui-validatebox" required="true" style="width: 200px;">
               				<font>*</font>
               			</td>
           			</tr>
           			<tr>
               			<td>期望到货日期：</td>
               			<td>
               				<input name="expectArrivalDate" class="add-datebox" required="true" style="width: 200px;">
                			<font>*</font>
               			</td>
           			</tr>
           			<tr>
               			<td>备注：</td>
               			<td>
               				<textarea name="remark" style="width:200px; height:120px; margin:5px;"></textarea>
               			</td>
           			</tr>
             		 	
           			<tr>
               			<td style="text-align: center;" colspan="2">
               				<a id="procurementDetail_save" class="easyui-linkbutton" iconCls="icon-save">保存</a>
               				<a class="easyui-linkbutton" iconCls="icon-reload"onclick="javascript:document.procurementDetailForm.reset()">重置</a>
               			</td>
           			</tr>
           		</table>
       		</form>
       	</div>
	</div> -->
	<div id="addInEntrepotWin" class="easyui-window" collapsible="false"
		minimizable="false" maximizable="false" iconCls="icon-add">
		<div align="center" style="margin: 20px;">
			<form action="#" method="post" id="addProductForm">
				<table width="310" border="0" align="center">
					<input type="hidden" name="goodsId" id="goodsId" />
					<input type="hidden" name="planId" id="add_detail_planId"/>
					<input type="hidden" name="id" id="detailId"/>
					<tr>
						<td colspan="2">
							<a class="easyui-linkbutton" iconCls="icon-add" id="choose-goods">选择物品</a>
						</td>
					</tr>
					
					<tr style="line-height: 30px;">
						<td width="110">产品名称：</td>
						<td id="goodsName"></td>
					</tr>
					<tr style="line-height: 30px;">
						<td>规格型号：</td>
						<td id="goodsModel"></td>
					</tr>
					
					<tr style="line-height: 30px;">
						<td>单位：</td>
						<td id="goodsUnit"></td>
					</tr>
					
					<tr style="line-height: 30px;">
						<td>品牌：</td>
						<td id="goodsBrand"></td>
					</tr>
					
					<tr>
						<td>数量：</td>
						<td>
							<input name="amount" class="easyui-validatebox" required="true"
								validType="nums" id="pro_amount" style="width: 200px;">
						</td>
					</tr>
					
					<tr>
						<td>预算金额：</td>
						<td>
							<input class="easyui-validatebox" required="true"
								name="budgetSum" id="pro_budgetSum" validType="nums" style="width: 200px;">
						</td>
					</tr>
					<tr>
						<td>期望到货日期：</td>
               			<td>
               				<input name="expectArrivalDate" id="pro_expectArrivalDate" class="add-datebox" required="true" style="width: 200px;">
               			</td>
					</tr>
					<tr>
						<td>用途：</td>
						<td>
							<textarea name="purpose" id="pro_purpose" style="width: 200px; height: 60px; margin: 5px;"></textarea>
						</td>
					</tr>
					<tr>
						<td>备注：</td>
						<td>
							<textarea name="remark" id="pro_remark" style="width: 200px; height: 60px; margin: 5px;"></textarea>
						</td>
					</tr>

					<tr>
						<td style="text-align: center;" colspan="2">
							<a class="easyui-linkbutton" iconCls="icon-save" id="addProduct-save">保存</a>
						</td>
					</tr>
				</table>
			</form>
		</div>
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
	
	<div id="addGoodsWin" class="easyui-window" collapsible="false"
		minimizable="false" maximizable="false" iconCls="icon-add">
		<div align="center" style="margin: 20px;">
			<form action="#" method="post" id="addGoodsForm">
				<input type="hidden" id="tid" name="typeId">
				<input type="hidden" id="addGoodsUnit" name="unit">
				<table width="300" border="0" align="center">
					
					<tr style="line-height: 30px;">
						<td width="60">物品名称：</td>
						<td>
							<input name="name" class="easyui-validatebox" required="true"/>
						</td>
					</tr>
					<tr style="line-height: 30px;">
						<td>规格型号：</td>
						<td>
							<input name="model" class="easyui-validatebox" required="true"/>
						</td>
					</tr>
					<tr style="line-height: 30px;">
						<td>品牌：</td>
						<td>
							<input name="brand" class="easyui-validatebox" />
						</td>
					</tr>
					
					<tr>
						<td>单位：</td>
						<td>
							<input id="goods-unit"/>
							<a class="easyui-linkbutton" iconCls="icon-reload" id="add-goods-reload">刷新</a>
						</td>
					</tr>
					
					<tr>
						<td>备注：</td>
						<td>
							<textarea name="remark" style="width: 200px; height: 30px; margin: 5px;"></textarea>
						</td>
					</tr>

					<tr>
						<td style="text-align: center;" colspan="2">
							<a class="easyui-linkbutton" iconCls="icon-save" id="add-goods-save">保存</a>
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
        	<input type="hidden" id="atta_planId" name="planId"/>
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