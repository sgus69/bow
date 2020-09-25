<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Swiper/4.5.1/js/swiper.min.js"></script>
<!-- 합쳐지고 최소화된 최신 CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<!-- 부가적인 테마 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">


<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Swiper/4.5.1/js/swiper.min.js"></script>
<meta charset="UTF-8">

<title>게시물 작성</title>
<style>
	#content{ min-height:50px;}
	.form-group {
    		margin-top: 30px;
    		margin-bottom: 15px;
    		
    		}
	.write_btn{
		margin-right: auto;
    	margin-left: auto;
	}
	.cancle{width: 15px; height: 15px; cursor: pointer; margin-left: 5px;}	
</style>
<script>
	
	$(document).ready(function(){
		var formObj = $("form[name='writeForm']");
		
		$(".write_btn").on("click", function(){
			
			if(fn_valiChk()){
				
				return false;
			}
			
			formObj.attr("action", "/board/re");
			formObj.attr("method", "post");
			formObj.submit();
		});
	});
	
	
	function fn_valiChk(){
		var regForm = $("form[name='writeForm'] .chk").length;
		var pass = document.writeForm.password;
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
	function len_chk(){
		var title = document.writeForm.title;
		var writer = document.writeForm.writer;
		var pass = document.writeForm.password;
		var content = document.writeForm.content;
		
		if(title.value.length > 70){
			alert("글자수는 70자로 제한됩니다.");
			title.value = title.value.substring(0,70);
			title.focus();
		}
			$('#counterT').html("(" + title.value.length + "/ 최대 70자)" );
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
			
		if(content.value.length > 1000){
			alert("글자수는 1000자로 제한됩니다.");
			content.value = content.value.substring(0,1000);
			content.focus();
		}
		$('#counter').html("(" + content.value.length + "/ 최대 1000자)" );
	}
	
	
	
</script>
</head>
<body>
<div class="container">
	<div id="nav">
		<%@ include file="../include/nav.jsp" %>
	</div>
	<form method="post" name="writeForm" enctype="multipart/form-data">
		<input type="hidden" name="bno" value="${view.bno }" readonly="readonly">
		<input type="hidden" name="ref" value="${view.ref }" readonly="readonly">
		<input type="hidden" name="step" value="${view.step }" readonly="readonly">
		<input type="hidden" name="lev" value="${view.lev }" readonly="readonly">
		
		<div class="form-group">
			<label for="title" class="col-sm-2 control-label">제목</label>
			<input type="text" id="title" name="title" onKeyup="len_chk()" class="chk form-control" title="제목을 입력하세요.">
		</div>
		<div>
		<span id="counterT">(0 / 최대70자)</span>
		</div>
		
		<div class="form-group">
		<label for="writer" class="col-sm-2 control-label">작성자</label>
		<input type="text" id="writer" class="chk form-control" onKeyup="len_chk()" name="writer"  title="작성자를 입력하세요.">
		</div>
		<div>
		<span id="counterW">(0 / 최대10자)</span>
		</div>
		
		<div class="form-group">
		<label for="password" class="col-sm-2 control-label">비밀번호</label>
		<input type="password" id="password" class="chk form-control" onKeyup="len_chk()" name="password" title="비밀번호를 입력하세요 최대10자." placeholder="숫자와 영문자 특수문자를 사용한 6~10자">
		</div>
		<div>
		<span id="counterP">(0 / 최대10자)</span>
		</div>
		<hr>
		 <!-- 파일업로드부분  -->
		<h4><label>첨부파일<span style="color: yellowgreen;" id="file_count">(0)</span><span style="font-size: 14px;" >&nbsp&nbsp※최대 5개(파일당 최대 10MB)</span>
		</label></h4>
		<div id="input_file">
		</div>
		
		<div id="select_file">
		<input type="file" name="files" id="file1" class="files"  onchange="after_input(this.id)"><br>
		</div>
		 <!-- 파일업로드부분 끝 -->
		<hr>
		<div class="form-group">
		<label class="col-sm-2 control-label">내용</label>
		<textarea rows="10" cols="50" name="content" onKeyup="len_chk()" id="content" class="chk form-control" title="내용을 입력하세요."></textarea>
		</div>
		<div>
		<span id="counter">(0 / 최대1000자)</span>
		</div>
		
		<div class="write_btn">
		<button type="button" class="write_btn btn btn-warning">작성</button>
		</div>		
	</form>
	
</div>
<script>
function after_input(this_id) {
	console.log("맨첨 :"+this_id);
	var thisId= "#"+this_id;
	//파일 사이즈 
	var fileSize= document.getElementById(this_id).files[0].size;
	console.log("fileSize :"+fileSize);
	
	//최대 사이즈
	var maxSize = 1024 * 1024 * 10;
	console.log("maxSize :"+maxSize);
	
	//파일사이즈 제한
	if(fileSize>maxSize){
		alert("파일용량은 10MB까지 가능합니다.");
		$(thisId).val("");
		return;
	}
	//파일 업로드 갯수 제한
	if($("input[name='files']").length>5){
		alert("파일 업로드는 5개까지 가능합니다.");
		$("#file_count").html('(5)');
		$(thisId).val("");
		return;
	}
	//첨부파일 갯수 변경
	$("#file_count").html('('+$(".files").length+')');
	
	//id값 셋팅
	var set_num= (this_id.substring(4, 5)*1)+1;
	console.log("셋넘:"+set_num);
	var set_id= "file"+set_num;
	console.log("셋아이디"+set_id);
	
	//파일명 가져오기
	var file_id="#"+this_id;
	console.log(file_id);
	var fileValue=$(file_id).val().split("\\");
	console.log(fileValue);
	var fileName=fileValue[fileValue.length-1];
	console.log(fileName);
	
	$(file_id).css("display","none");
	$("#input_file").append('<div class='+this_id+'><span>'+fileName+'</span><label class="input_files"><button type="button" onclick="remove_file(`'+this_id+'`)" style="display: none;"></button><img class="cancle" alt="취소" src="../resources/images/cancle.png"></label><br></div>');
	$("#select_file").append('<input type="file" name="files" id='+set_id+' class="files" onchange="after_input(this.id)" >');
}
function remove_file(get_class) {
	console.log("리무브 겟클래스"+get_class)
	var remove_id="#"+get_class;
	var remove_class="."+get_class;
	$(remove_id).remove();
	$(remove_class).remove();
	 $("#file_count").html('('+($(".files").length-1)+')');
}
</script>
</body>
</html>