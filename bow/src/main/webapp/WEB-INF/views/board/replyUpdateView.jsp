<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Swiper/4.5.1/js/swiper.min.js"></script>
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<!-- 합쳐지고 최소화된 최신 CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<!-- 부가적인 테마 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">

<meta charset="UTF-8">
<style type="text/css">

</style>
<title>게시판</title>
</head>
	<script type="text/javascript">
		$(document).ready(function(){
			var formObj = $("form[name='updateForm']");
			
			//수정 취소
			$(".cancel_btn").on("click", function(){
				location.href = "/board/view?bno=${replyUpdate.bno}"
					   + "&page=${scri.page}"
					   + "&perPageNum=${scri.perPageNum}"
					   + "&searchType=${scri.searchType}"
					   + "&keyword=${scri.keyword}";
			})
			
			//글자수 받아오기
			var content = document.updateForm.content;
			$('#counter').html("(" + content.value.length + " / 최대 1000자)" );
			
		});
		
		function fn_valiChk(){
			var regForm = $("form[name='updateForm'] .chk").length;
			for(var i = 0; i<regForm; i++){
				var text = $(".chk").eq(i).val();
				
				if(text.trim() == "" || text.trim() == null || text.trim() <1 ){
					alert("텍스트가 없습니다. "+ $(".chk").eq(i).attr("title"));
					$(".chk").eq(i).focus();						
					return true;
				}
				$(".chk").eq(i).val(text.trim());
			}
		}
		
		function len_chk(){
			var content = document.updateForm.content;
			
			if(content.value.length > 300){
				alert("글자수는 300자로 제한됩니다.");
				content.value = content.value.substring(0,300);
				content.focus();
			}
			$('#counter').html("(" + content.value.length + "/ 최대 300자)" );
		}
	</script>
<body>
	
	<div id="root">
			<header>
				<h1> 게시판</h1>
			</header>
			<hr />
			 
			<div>
				<%@include file="../include/nav.jsp" %>
			</div>
			<hr />
			
			<section id="container">
				<form name="updateForm" role="form" method="post" action="/board/replyUpdate">
					<input type="hidden" name="bno" value="${replyUpdate.bno}" readonly="readonly"/>
					<input type="hidden" id="rno" name="rno" value="${replyUpdate.rno}" />
					<input type="hidden" id="page" name="page" value="${scri.page}"> 
					<input type="hidden" id="perPageNum" name="perPageNum" value="${scri.perPageNum}"> 
					<input type="hidden" id="searchType" name="searchType" value="${scri.searchType}"> 
					<input type="hidden" id="keyword" name="keyword" value="${scri.keyword}"> 
					
					<div class="form-group">
						<label for="content" class="col-sm-2 control-label">내용</label>
						<textarea rows="10" cols="40" onKeyup="len_chk()" name="content" id="content" class="chk form-control" title="내용을 입력하세요."><c:out value="${replyUpdate.content }"/></textarea>
						<div>
						<span id="counter">( 0 / 최대1000자)</span>
						</div>
					</div>
					<div>
						<button type="submit" class="update_btn btn btn-success">저장</button>
						<button type="button" class="cancel_btn btn btn-danger">취소</button>
					</div>
				</form>
			</section>
			<hr/>
		</div>
</body>
</html>
