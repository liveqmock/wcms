<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>库存查询</title>
<link id="easyuiTheme" href="<%=request.getContextPath()%>/themes/metro/easyui.css" rel="stylesheet" type="text/css" />
<link href="<%=request.getContextPath()%>/themes/icon.css" rel="stylesheet" type="text/css" />
<script src="<%=request.getContextPath()%>/js/jquery.min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/jquery.easyui.min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/easyui-lang-zh_CN.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/outlook2.js" type="text/javascript"></script>

<script type="text/javascript">
	$(function(){
		$('#tt').tree({
    	    url:'<%=request.getContextPath()%>/sys/getGoodsTypeTree',
    	    onClick: function(node){
    	    	$('#tid').val(node.id);
    			$('#goodsList').datagrid({url:'<%=request.getContextPath()%>/entrepot/getGoodsStockByTid?tid=' + node.id});
    		}
    	});
		
		$('#goodsList').datagrid({
			title:'物品库',
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			pagination:true,
			columns:[[
				{field:'goodsName',title:'名称',width:80},
				{field:'goodsModel',title:'规格',width:80},
				{field:'goodsBrand',title:'品牌',width:80},
				{field:'goodsUnitName',title:'单位',width:80},
				{field:'entrepotName',title:'仓库',width:80},
				{field:'shelfName',title:'货架',width:80},
				{field:'quantity',title:'库存量',width:80},
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
	});
</script>
</head>
<body  class="easyui-layout" >
	<div region="west" style="width:180px;" id="west">
		<div style="height: 20px;"></div>
      	<ul id="tt" class="easyui-tree"></ul>
    </div>
    
    <div region="center">
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
</body>
</html>