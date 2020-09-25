<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!-- 합쳐지고 최소화된 최신 CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<!-- 부가적인 테마 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">
<style type="text/css">
	#content{
		word-break:break-all;
		border:1px;
		background-color: #eee;
		opacity:1;
		padding: 6px 12px;
		font-size: 14px;
		    color: #555;
        border: 1px solid #ccc;
    	border-radius: 4px;
    	box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
    	margin-top:5px;
	}
	#btnbox{
		margin-bottom: 10px;
	}
	.list_btn{
		float:right;
	}
</style>
<script src="//code.jquery.com/jquery-1.11.3.min.js"></script>
<script src="//code.jquery.com/jquery-migrate-1.2.1.min.js"></script>
<title>게시물 조회</title>
</head>
<script>
	$(document).ready(function(){
		//댓글수정view
		$(".replyUpdateBtn").on("click", function(){
			console.log("댓글수정");
			if(fn_passChk()){
				return false;
			}
			
			
				location.href = "/board/replyUpdateView?bno=${view.bno}"
					  + "&page=${scri.page}"
					  +	"&perPageNum=${scri.perPageNum}"	
					  + "&searchType=${scri.searchType}"
					  + "&keyword=${scri.keyword}"
					  + "&rno="+$(this).attr("data-rno");
			
		});
		//댓글삭제view
		$(".replyDeleteBtn").on("click", function(){

			if(fn_passChk()){
				return false;
			}
			
			location.href = "/board/replyDeleteView?bno=${view.bno}"
				  + "&page=${scri.page}"
				  +	"&perPageNum=${scri.perPageNum}"	
				  + "&searchType=${scri.searchType}"
				  + "&keyword=${scri.keyword}"
				  + "&rno="+$(this).attr("data-rno");
				  });
	
	});	
	
	function fn_passChk(){
		var inputPw = prompt('비밀번호를 입력하세요.','');	
		var userPw = '<c:out value= "${list.password}"/>';
		if(inputPw == null){
			return true;
		}
		if(inputPw == userPw){
			return false;
		}else{
			alert("비밀번호가 일치하지 않습니다.");
		return true;
		}
	}

	function len_chk(){
		var writer = document.replyForm.writer;
		var pass = document.replyForm.password;
		var content = document.replyForm.content;

		if(writer.value.length > 10){
			alert("글자수는 10자로 제한됩니다.");
			writer.value = writer.value.substring(0,10);
			writer.focus();
		}
			$('#counterW').html("(" + writer.value.length + "/ 최대 10자)" );
			
		if(pass.value.length > 10){
			alert("비밀번호는 10자로 제한됩니다.");
			pass.value = pass.value.substring(0,10);
			pass.focus();
		}
			$('#counterP').html("(" + pass.value.length + "/ 최대 10자)" );
			
		if(content.value.length > 300){
			alert("글자수는 300자로 제한됩니다.");
			content.value = content.value.substring(0,300);
			content.focus();
		}
		$('#counter').html("(" + content.value.length + "/ 최대 300자)" );
	}
	
	function fn_valiChk(){
		var regForm = $("form[name='replyForm'] .chk").length;
		var pass = document.replyForm.password;
		var check = /^(?=.*[a-zA-Z])(?=.*[~`!@#$%?+_\\^&*()-])(?=.*[0-9]).{6,10}$/;
		
		for(var i = 0; i < regForm; i++){ 
			var text = $(".chk").eq(i).val();
			if(text.trim() == "" || text.trim() == null || text.trim() < 1 ){
				alert($(".chk").eq(i).attr("title"));
				$(".chk").eq(i).focus();
				return true;
			}
			 $(".chk").eq(i).val(text.trim());
			//마지막에 트림한 문자열을 다시 밸류로 삽입
		}
		if(pass.value.length < 6){
			alert("비밀번호는 6자리 이상10자 미만입니다.");
			pass.focus();
			return true;
		}else if(!check.test(pass.value)){
			alert("비밀번호는 영문, 숫자, 특수문자의 조합으로 입력해주세요");
			pass.focus();
			return true;
		}
	 
	}
</script>
<body>
	<div class="container">
			<!-- 댓글 -->
			<hr>			
			<div id="reply">
		
				<ol class="replyList">
					<c:forEach items="${repList }" var="repList">
					
					<li>
						<p>
						작성자 : <c:out value="${repList.writer }"/> <br>
						비번 : <c:out value="${repList.password }"/> <br>
						작성날짜 :<fmt:formatDate value="${repList.regDate }" pattern="yy.MM.dd HH:mm"/>
						</p>
						<p><c:out value="${repList.content }" /></p>
						<div>
							<button type="button" class= "replyUpdateBtn btn btn-warning" data-pass="${repList.password} data-rno="${repList.rno}">수정</button>
							<button type="button" class="replyDeleteBtn btn btn-danger" data-rno="${repList.rno}">삭제</button>
						</div>
					</li>
					<hr>
					</c:forEach>
				</ol>
			</div> 
			<!--블로그에서 하는 ajax댓글목록  -->
			<!-- 
			<div class="my-3 p-3 bg-white rounded shadow-sm" style="padding-top: 10px">
				<div id="replyList"></div>
			</div>  -->
			<section id="container">
				<form name="replyForm" method="post" class="form-horizontal">
					<input type="hidden" id="bno" name="bno" value="${view.bno }">
					<input type="hidden" id="page" name="page" value="${scri.page}">
					<input type="hidden" id="perPageNum" name="perPageNum" value="${scri.perPageNum }">
					<input type="hidden" id="searchType" name="searchType" value="${scri.searchType}">
					<input type="hidden" id="keyword" name="keyword" value="${scri.keyword}">
					
					<div class="form-group">
						<label for="writer"  class="col-sm-2 control-label" >댓글 작성자</label>
						<div class="col-sm-10">
							<input type="text" id="rWriter" name="writer" onKeyup="len_chk()" class="chk form-control" onKeyup="len_chk()" title="작성자를 입력하세요.">
						<span id="counterW">(0 / 최대10자)</span>
						</div>
					</div>	
						<br>
					<div class="form-group">
						<label for="password"  class="col-sm-2 control-label" >댓글 비밀번호</label>
						<div class="col-sm-10">
							<input type="password" id="rPassword" onKeyup="len_chk()" class="chk form-control" name="password" onKeyup="len_chk()" maxlength="20" title="비밀번호를 입력하세요 최대10자." placeholder="영자숫자특수문자를 포함한6~10자">
						<span id="counterP">(0 / 최대10자)</span>
						</div>
					</div>	
						<br>
						
					<div class="form-group">
						<label for="content"  class="col-sm-2 control-label">댓글 내용</label>
						<div class="col-sm-10">
							<textarea id="rContent" name="content" onKeyup="len_chk()" class="chk form-control" title="내용을 입력하세요."></textarea>
						<span id="counter">(0 / 최대300자)</span>
						</div>
					</div>
					
					<div class="form-group">
						<div class="col-sm-offset-2 col-sm-10">
							<button type="button" class="replyWriteBtn btn btn-success">작성</button>
						</div>
					</div>
				</form>
			</section>
		</div>
	</body>

</html>
