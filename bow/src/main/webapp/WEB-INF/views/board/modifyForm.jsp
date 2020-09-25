<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<!-- 합쳐지고 최소화된 최신 CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<!-- 부가적인 테마 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">
<meta charset="UTF-8">
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<style>
	input[type=file]{
		display: inline-block;
	}
	#file{display:inlin-block;}
	#addFile{
		float:left;
		margin-right: 5px;
	}
	#fileDiv{ margin-left:100px;}
	
	img{width: 15px; height: 15px; cursor: pointer; margin-left: 5px;}
</style>	
<script type="text/javascript">
		var gfv_count = 1;

		$(document).ready(function(){
			
			//글자수 받아오기
			var title = document.updateForm.title;
			$('#counterT').html("(" + title.value.length + " / 최대70자)" );
			
			var content = document.updateForm.content;
			$('#counter').html("(" + content.value.length + " / 최대 1000자)" );
			
			
			
			var formObj = $("form[name='updateForm']");
			
			$(".cancel_btn").on("click", function(){
				event.preventDefault();
				location.href="/board/view?bno=${view.bno}"
							+ "&page=${scri.page}"
							+ "&perPageNum=${scri.perPageNum}"
							+ "&searchType=${scri.searchType}"
							+ "&keyword=${scri.keyword}";
			})
			$(".update_btn").on("click", function(){
				if(fn_valiChk()){
					return false;
				}
				formObj.attr("action", "/board/modify");
				formObj.attr("method", "post");
				formObj.submit();
			});
			
			//파일추가버튼
			$("#addFile").on ("click", function(e){
				e.preventDefault();
				fn_addFile();
			});
			$("a[name^='delete']").on("click", function(e){
				e.preventDefault();
				fn_deleteFile($(this));
			});

		});
		
		//파일추가
		function fn_addFile(){
	var str ="<p><input type='file' name='file_"+(gfv_count)+"' name='file_"+(gfv_count)+"'>"
			+"<a href='#this' class='btn' name='delete_"+(gfv_count)+"' name='delete_"+(gfv_count)+"'>삭제</a></p>"
			
			$('#fileDiv').append(str);
			$("#delete_"+(gfv_count++)).on("click", function(e){
				e.preventDefault();
				fn_deleteFile($(this));
			});
		}
		
		//파일삭제
		function fn_deleteFile(obj){
			obj.parent().remove();
			
		}
		
		
		//비밀번호체크 글앞공백 트림
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
		//온키업 펑션
		function len_chk(){
			var title = document.updateForm.title;
			var content = document.updateForm.content;
			
			if(title.value.length > 70){
				alert("글자수는 70자로 제한됩니다.");
				title.value = title.value.substring(0,70);
				title.focus();
			}
			$('#counterT').html("(" + title.value.length + "/ 최대70자)" );
			
			if(content.value.length > 1000){
				alert("글자수는 1000자로 제한됩니다.");
				content.value = content.value.substring(0,1000);
				content.focus();
			}
			$('#counter').html("(" + content.value.length + "/ 최대 1000자)" );
		}
		
</script>
<title>게시물 수정</title>
</head>
<body>
<div class="container">
	<div id="nav">
		<%@ include file="../include/nav.jsp" %>
	</div>
	<form method="post" name="updateForm" enctype="multipart/form-data">
		
		<input type="hidden" name="bno" value="${view.bno }" readonly="readonly">
		
		<div class="form-group">
			<label for="title" class="col-sm-2 control-label">제목</label>
			<input type="text" onKeyup="len_chk()" name="title" id="title" class="chk form-control" title="제목을 입력하세요." value='<c:out value="${view.title }" />'>
			<div id="counterT">( 0 / 최대70자)</div>
			<br>
			
			<label for="writer" class="col-sm-2 control-label">작성자</label>
			<input type="text" onKeyup="len_chk()" name="writer" id="writer" class="chk form-control" maxlength="10" title="작성자를 입력하세요." value='<c:out value="${view.writer }" />' readonly="readonly"><br>
			
		</div>
		
		<%-- <div class="form-group">
			<label for="file" class="col-sm-2 control-label" style="margin-top:6px;">파일업로드</label>
			<br><br>
			<button type="button" class="btn btn-warning" id="addFile">파일추가</button>
			
		<div id="fileDiv">
			<p>
				<c:forEach var="row" items="${fvoinfo }" varStatus="var"> 
				<c:if test="${row.delGb eq'N' }">
	            <p> 
	            <input type="hidden" id="IDX_${var.index }" name="IDX_${var.index }
	            " value="${row.fno }"> 
	            <span><a href="#this" id="name_${var.index }" name="name_${var.index }">${row.oname }</a></span>
	            <input type = "file" id="file_${var.index }" name="file_${var.index }">
	            <span>(${row.fsize }kb)</span>
	            <a href='#this' class='btn' id="delete_${var.index }" name='delete${var.index }'>삭제</a>
	            </p> 
	       	 	</c:if>     
	            </c:forEach>
			</p>
		</div>
		</div> --%>
		 		
		<div class="form-group">
		<c:choose>
		<c:when test="${empty view.b_files }">
		<h3>첨부파일<span style="color: #FF5E00;" id="file_count">(0)</span></h3>
		<div id="input_file">
		</div>
		</c:when>
		<c:when test="${not empty view.b_files }">
		<c:set var="files" value="${fn:split(view.b_files,'*') }"/>
		<c:set var="file_names" value="${fn:split(view.b_file_names,'*') }"/>
		<h4><label>첨부파일<span style="color: yellowgreen;" id="file_count">(${fn:length(file_names) })</span>
		<span style="font-size: 14px;" >&nbsp&nbsp※최대 5개(파일당 최대 10MB)</span>
		</label></h4>
		
			<div id="input_file">
			<c:forEach var="files1" items="${file_names }" varStatus="status">
				<div class="file${status.index+1 }"><span class="files">${files1 }</span>
				<label class="input_files"><button type="button" onclick="remove_file('file${status.index+1 }')" style="display: none;"></button>
				<img class="cancle" alt="취소" src="../resources/images/cancle.png"></label><br>
				<input type="text" name="ori_file_names" value="${files1 }" style="display:none; ">
				<input type="text" name="ori_files" value="${files[status.index] }" style="display: none;">
				</div>
			</c:forEach>
			</div>
		</c:when>		
		</c:choose>
		</div>
		<div id="select_file">
		<input type="file" name="files" id="file${fn:length(file_names)+1 }" class="files" onchange="after_input(this.id)"><br>
		</div> 
		
		
		<br>
		<div class="form-group">
			<hr>
			<br>
			<label for="content" class="col-sm-2 control-label">내용</label>
			<textarea rows="10" cols="50" onKeyup="len_chk()" name="content" id="content" class="chk form-control" title="내용을 입력하세요."><c:out value="${view.content }"/></textarea>
			
			<div>
			<span id="counter">( 0 / 최대1000자)</span>
			</div>
			
		</div>
		<button type="button" class="update_btn btn btn-success">완료</button>
		<button type="button" class="cancel_btn btn btn-danger">취소</button>
				
	</form>
</div>
<script type="text/javascript">

function remove_file(get_class) {
	var remove_id="#"+get_class;
	var remove_class="."+get_class;
	$(remove_id).remove();
	$(remove_class).remove();
	 $("#file_count").html('('+($(".files").length-1)+')');
}

function after_input(this_id) {
	
	$("#file_count").html('('+$(".files").length+')');
	
	//id값 셋팅
	var thisId= "#"+this_id;
	console.log(thisId);
	var set_num= (this_id.substring(4, 5)*1)+1;
	console.log(set_num);
	var set_id= "file"+set_num;
	console.log(set_id);
	//파일 사이즈 
	var fileSize= document.getElementById(this_id).files[0].size;
	//최대 사이즈
	var maxSize = 1024 * 1024 * 10;
	
	//파일사이즈 제한
	if(fileSize>maxSize){
		alert("파일용량은 10MB까지 가능합니다.");
		$(thisId).val("");
		return;
	}
	
	
	if($(".files").length>5){
		alert("파일 업로드는 5개까지 가능합니다.");
		$("#file_count").html('(5)');
		$(thisId).val("");
		return;
	}
	
					
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

</script>
</body>
</html>