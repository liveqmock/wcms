<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>入库</title>
<link id="easyuiTheme" href="<%=request.getContextPath()%>/themes/metro/easyui.css"	rel="stylesheet" type="text/css" />
<link href="<%=request.getContextPath()%>/themes/icon.css" rel="stylesheet" type="text/css" />
<script src="<%=request.getContextPath()%>/js/jquery.min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/jquery.easyui.min.js"	type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/easyui-lang-zh_CN.js"	type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/outlook2.js" type="text/javascript"></script>

<script type="text/javascript">
	$(function(){
		$('.datebox').datebox({
			editable:false
		});
		
		$('#entrepotLogList').datagrid({
			url: '<%=request.getContextPath()%>/entrepot/getInEntrepotList',
			toolbar:[
				{iconCls : 'icon-add', text : '入库', 
				 handler: 
					function(){
						addInEntrepot();
				 	}
				}
			],
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			pagination:true,
			columns:[[
				{field:'code',title:'编号',width:80},		
				{field:'goodsName',title:'名称',width:80},
				{field:'goodsModel',title:'规格',width:80},
				{field:'goodsBrand',title:'品牌',width:80},
				{field:'goodsUnitName',title:'单位',width:80},
				{field:'createTimeStr',title:'入库时间',width:80},
				{field:'receiveUserName',title:'接收人',width:80},
				{field:'amount',title:'数量',width:80},
				{field:'unitPrice',title:'单价(元)',width:80},
				{field:'remark',title:'备注',width:80}
			]]
		});
		//分页
		var p = $('#entrepotLogList').datagrid('getPager'); 
		p.pagination({  
	        pageSize : 10,// 每页显示的记录条数，默认为20  
	        pageList : [ 10, 20, 30 ],// 可以设置每页记录条数的列表  
	        beforePageText : '第',// 页数文本框前显示的汉字  
	        afterPageText : '页    共 {pages} 页',  
	        displayMsg : '当前显示 {from} - {to} 条记录   共 {total} 条记录'   
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
		
		//加载所有仓库管理员
		//$('#add-receiver').combobox({
			//url:'<%=request.getContextPath()%>/user/getUsersByRole?roleCode=CKGLY',
			//valueField:'id',
			//textField:'text',
			//required:true,
			//editable:false
		//});
		
		//加载所有接收人
		//$('#search-receiveUser').combobox({
			//valueField:'id',
			//textField:'text',
			//editable:false
		//});
		
		$.ajax({
			url:'<%=request.getContextPath()%>/user/getUsersByRole?roleCode=CKGLY',
			type:'post',
			dataType:'json',
			success:function(data){
				data.unshift({"id":"", "text":"全部"});
				$('#search-receiveUser').combobox('loadData', data);
			},
			async:true
		});
		
		//加载所有仓库
		$('#add-entrepot').combobox({
			url:'<%=request.getContextPath()%>/entrepot/getEntrepotTree',
			valueField:'id',
			textField:'text',
			required:true,
			editable:false,
			onChange:function(newValue, oldValue){
				$('#add-shelf').combobox({
					url:'<%=request.getContextPath()%>/entrepot/getAllShelfsByEid?eid=' + newValue
				});
			}
		});
		
		//初始化货架
		$('#add-shelf').combobox({
			valueField:'id',
			textField:'name',
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
		
		//搜索入库记录
		$('#search').on('click', function(){
			var queryParams = {};
			var params = $('.searchParam');
			for(i=0;i<params.length;i++){
				if($(params[i]).val() != ''){
					queryParams[$(params[i]).attr('name')] = $(params[i]).val();
				}
			}
			
			queryParams.createDateStrBegin = $('#createDateStrBegin').datebox('getValue');
			queryParams.createDateStrEnd = $('#createDateStrEnd').datebox('getValue');
			//queryParams.receiveUser = $('#search-receiveUser').combobox('getValue');
			
			$('#entrepotLogList').datagrid('options').queryParams = queryParams;
			$('#entrepotLogList').datagrid('reload');
		});
		
		//搜索物品库
		$('#goods-search').on('click', function(){
			var queryParams = {};
			var params = $('.queryParam');
			for(i=0;i<params.length;i++){
				if($(params[i]).val() != ''){
					queryParams[$(params[i]).attr('name')] = $(params[i]).val();
				}
			}
			
			$('#goodsList').datagrid('options').queryParams = queryParams;
			$('#goodsList').datagrid('reload');
		});
		
		$('#viewWin').window({
            title: '产品XXXXX',
            width: 1000,
            modal: true,
            shadow: true,
            closed: true,
            height: 350,
            top:0,
            left:50
        });
		
		$('#addInEntrepotWin').window({
			title: '入库',
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
				if($(this).form('validate')){
					MaskUtil.mask();
				}
				$('#addGoodsUnit').val($('#goods-unit').combobox('getValue'));
				return $('#addGoodsForm').form('validate');
			},
			success:function(data){
				MaskUtil.unmask();
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
		
		//新增
		$('#addForm').form({
			url:'<%=request.getContextPath()%>/entrepot/inEntrepot',
			onSubmit:function(){
				if(strIsNull($('#goodsId').val())){
					msgShow('提示','请选择物品','warning');
					return false;
				}
				
				if($(this).form('validate')){
					MaskUtil.mask();
				}
				
				//$('#addReceiver').val($('#add-receiver').combobox('getValue'));
				$('#addEntrepot').val($('#add-entrepot').combobox('getValue'));
				$('#addShelf').val($('#add-shelf').combobox('getValue'));
				
				return $(this).form('validate');
			},
			success:function(data){
				MaskUtil.unmask();
				var data = eval('(' + data + ')');
				if(data.flag){
					msgShow('提示','保存成功','info');
					$('#addInEntrepotWin').window('close');
					$('#entrepotLogList').datagrid('reload');
					$('#addForm').form('reset');
					
					$('#goodsId').val('');
					$('#goodsName').html('');
					$('#goodsModel').html('');
					$('#goodsUnit').html('');
					$('#goodsBrand').html('');
				}else{
					msgShow('提示','保存失败','error');
				}
			}
		});
		
		$('#add-save').on('click', function(){
			$('#addForm').submit();
		});
		
	});
	
	//新增产品
	function addInEntrepot(){
		$('#addInEntrepotWin').window('open');
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
</script>
</head>
<body>
	<table
		style="width: 100%; height: auto; border: 1px solid #ccc; font-size: 12px; color: #888; padding: 5px;">
		<tr style="line-height: 30px;">
			<td style="text-align: right;">编号：</td>
			<td style="text-align: left;">
				<input style="width: 75%; height: 17px;" class="searchParam" name="code"/>
			</td>
			<td style="text-align: right;">名称：</td>
			<td style="text-align: left;">
				<input style="width: 75%; height: 17px;" class="searchParam" name="name"/>
			</td>
			<td style="text-align: right;">规格：</td>
			<td style="text-align: left;">
				<input style="width: 75%; height: 17px;" class="searchParam" name="model"/>
			</td>

			<td style="text-align: right;">品牌：</td>
			<td style="text-align: left;">
				<input style="width: 75%; height: 17px;" class="searchParam" name="brand"/>
			</td>
		</tr>
		<tr>
			<td style="text-align: right;">入库时间：</td>
			<td style="text-align: left;">
				<input style="width: 180px;" class="datebox" id="createDateStrBegin"/>
			</td>
			<td style="text-align: left;">-</td>
			<td style="text-align: left;">
				<input style="width: 180px;" class="datebox" id="createDateStrEnd"/>
			</td>
			<td style="text-align: right;">接收人：</td>
			<td style="text-align: left;">
				<input style="width: 180px;" class="searchParam" name="receiveUserName"/>
			</td>

			<td style="text-align: right;"></td>
			<td style="text-align: left;">
				<a id="search" class="easyui-linkbutton" style="height: 25px;"
					iconCls="icon-search">搜索</a>
			</td>
		</tr>

	</table>
	<div style="height: 10px;"></div>
	<table id="entrepotLogList">
	</table>
	<div id="viewWin" class="easyui-window" collapsible="false"
		minimizable="false" maximizable="false" iconCls="icon-search">
		<table style="width: 100%;">
			<tr style="line-height: 25px;">
				<td style="width: 8%; text-align: right;">产品名称：</td>
				<td style="width: 8%; text-align: left;">DT2014001</td>

				<td style="width: 8%; text-align: right;">规格型号：</td>
				<td style="width: 8%; text-align: left;">123456
				<td style="width: 8%; text-align: right;">单位：</td>
				<td style="width: 20%; text-align: left;">武汉大通窑炉机械设备有限公司</td>

				<td style="width: 8%; text-align: right;">单价(元)：</td>
				<td style="width: 8%; text-align: left;">100</td>

				<td style="width: 8%; text-align: right;">备注：</td>
				<td style="width: 15%; text-align: left;">库存紧张</td>
			</tr>

		</table>

		<table id="viewProductList"></table>

		<div style="height: 10px;"></div>

		<table id="viewOrderAtta"></table>
	</div>
	
	<div id="addInEntrepotWin" class="easyui-window" collapsible="false"
		minimizable="false" maximizable="false" iconCls="icon-add">
		<div align="center" style="margin: 20px;">
			<form action="#" method="post" id="addForm">
				<input type="hidden" id="goodsId" name="goodsId"/>
				<input type="hidden" name="type" value="0">
				<table width="300" border="0" align="center">
					<tr>
						<td colspan="2">
							<a class="easyui-linkbutton" iconCls="icon-add" id="choose-goods">选择物品</a>
						</td>
					</tr>
					
					<tr style="line-height: 30px;">
						<td width="60">产品名称：</td>
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
								validType="nums" style="width: 200px;">
						</td>
					</tr>
					
					<tr>
						<td>单价(元)：</td>
						<td>
							<input class="easyui-validatebox" required="true"
								validType="nums" style="width: 200px;" name="unitPrice">
						</td>
					</tr>
					
					<tr>
						<td>收货人：</td>
						<td>
							<!--
							<input id="add-receiver" style="width: 200px;"/>
							<input type="hidden" id="addReceiver" name="receiveUserId"/>
							-->
							<input id="addReceiver" name="receiveUserName" style="width: 200px;"/>
						</td>
					</tr>
					
					<tr>
						<td>仓库：</td>
						<td>
							<input id="add-entrepot" style="width: 200px;"/>
							<input type="hidden" id="addEntrepot" name="entrepotId"/>
						</td>
					</tr>
					
					<tr>
						<td>货架：</td>
						<td>
							<input id="add-shelf" style="width: 200px;"/>
							<input type="hidden" id="addShelf" name="shelfId"/>
						</td>
					</tr>
					
					<tr>
						<td>备注：</td>
						<td>
							<textarea name="remark" style="width: 200px; height: 60px; margin: 5px;"></textarea>
						</td>
					</tr>

					<tr>
						<td style="text-align: center;" colspan="2">
							<a class="easyui-linkbutton" iconCls="icon-save" id="add-save">保存</a>
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
						<input style="width: 75%; height: 17px;" class="queryParam" id="search-name" name="name"/>
					</td>
					<td style="text-align: right;">编码：</td>
					<td style="text-align: left;">
						<input style="width: 75%; height: 17px;" class="queryParam" id="search-code" name="code"/>
					</td>
					<td style="text-align: right;"></td>
					<td style="text-align: left;"></td>
				</tr>
				<tr>
					<td style="text-align: right;">规格：</td>
					<td style="text-align: left;">
						<input style="width: 75%; height: 17px;" class="queryParam" id="search-model" name="model"/>
					</td>
					<td style="text-align: right;">品牌：</td>
					<td style="text-align: left;">
						<input style="width: 75%; height: 17px;" class="queryParam" id="search-brand" name="brand"/>
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
</body>
</html>