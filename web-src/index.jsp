<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DICTYPE html>
<html lang="zh-cn">
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<script type="text/javascript">
	
			if(self.frameElement.tagName=="IFRAME"){
				window.parent.location = '<%=request.getContextPath()%>/index.jsp';
			}
		</script>
		<title>综合管理系统-登陆</title>
		
		<!-- Bootstrap core CSS -->
		<link href="<%=request.getContextPath() %>/css/bootstrap.css" rel="stylesheet">
		<style>
			body{
				padding-top: 40px;
				padding-bottom: 40px;
				background-color: #eee;
			}
			.form-signin{
				max-width: 330px;
				padding: 15px;
				margin: 0 auto;
			}
			.form-signin .form-signin-heading,
			.form-signin .checkbox{
				margin-bottom: 10px;
			}
			.form-signin .checkbox{
				font-weight: normal;
			}
			.form-signin .form-control{
				position: relative;
				font-size: 16px;
				height: auto;
				padding:  10px;
				-webkit-box-sizing: border-box;
				   -moz-box-sizing: border-box;
						box-sizing: border-box;
			}
			.form-signin .form-control:focus{
				z-index: 2;
			}
			.form-signin input[type="text"]{
				margin-bottom: -1px;
				border-bottom-left-radius: 0;
				border-bottom-right-radius: 0;
			}
			.form-signin input[type="password"]{
				margin-bottom: 10px;
				border-bottom-left-radius: 0;
				border-bottom-right-radius: 0;
			}
		</style>
		<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery.min.js"></script>
		<script type="text/javascript">
			function clearUp(){
				var msg = document.getElementById("msg").value;
				if(msg == ""){
					document.getElementById("msgDiv").style.display = "none";
				}else{
					window.setTimeout(hide,8000); 
				}
			}
			
			function hide(){
				document.getElementById("msgDiv").style.display = "none";
			}
			
			$(function(){
				$('#loginForm').submit(function(){
					$.ajax({
						url:"<%=request.getContextPath()%>/login/login",
						type:"post",
						dataType:"json",
						data:$('#loginForm').serialize(),
						success:function(data,textStatus){
							if(data.flag){
								window.location = "<%=request.getContextPath()%>/main.jsp";
							}else{
								document.getElementById("msgDiv").style.display = "block";
								$('#msgDiv').html("用户名或密码错误");
								window.setTimeout(hide,8000);
							}
						},
						error:function(textStatus){
							alert(textStatus.status);
							alert("出错，请联系管理员");
						},
						async:false
					});
					return false;
				});
			});
		</script>
	</head>
	<body>
		<div class="container">
			<div class="navbar navbar-default" role="navigation">
				<div class="navbar-header">
					<button type="button" class="navbar-toggle" data-toggle="collapse"
						data-target=".navbar-collapse">
						<span class="sr-only">Toggle navigation</span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
					</button>
					<a class="navbar-brand" href="#">综合管理系统</a>
				</div>
			</div>
			
			<form id="loginForm" class="form-signin" role="form" method="post" action="#">
				<h2 class="form-signin-heading">登陆</h2>
				<input name="username" type="text" class="form-control" placeholder="用户名" required autofocus/>
				<input name="password" type="password" class="form-control" placeholder="密码" required/>
				<label class="checkbox">
					<input type="checkbox" value="remenber-me"/>记住账号
				</label>
				<button class="btn btn-lg btn-primary btn-block" type="submit">登陆</button>
				<div class="alert alert-danger" style="display: none" id="msgDiv">
      			</div>
			</form>
		</div><!-- /container -->
		<!-- Bootstrap core JavaScript
    		================================================== -->
    	<!-- Placed at the end of the document so the pages load faster -->
	</body>
</html>








