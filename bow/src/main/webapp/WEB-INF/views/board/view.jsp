<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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
		border:1px;
		opacity:1;
		padding: 6px 12px;
		font-size: 14px;
		word-break:break-all;
		    color: #555;
    	margin-top:5px;
    	height: auto;
    	min-height:300px;
    	overflow:hidden;
    	
	}
	#btnbox{
		margin-bottom: 10px;
	}
	.list_btn{
		float:right;
	}
	.wrbox{
		padding-left:10px;
		
	}
	.gray{
		color:gray;
	}
	.whole{
		/* background-color: #eee;
			border: 1px solid #ccc;
			box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
		 */
		border-radius: 4px;
		
	}
	h3{padding-left:10px;}
	.wpbox{
			padding: 3px 6px;
			box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
			margin: 3px;
		}
	#rWriter{width:350px; border: 1px solid #ccc; border-radius: 4px; }
	#rPassword{width:380px; border: 1px solid #ccc; border-radius: 4px; margin-left:10px;}
	::placeholder{ color: #aaa;}
	.replyWriteBtn{
		position: absolute;
    	left: 100%;
    	margin:10px;
	}
	#replyList{ margin-top:20px;}
	img { 
		margin-left: 5px;
		with: 16px; height:16px; 
		vertical-align: middle;"
	}
	
</style>
<script src="//code.jquery.com/jquery-1.11.3.min.js"></script>
<script src="//code.jquery.com/jquery-migrate-1.2.1.min.js"></script>
<title>게시물 조회</title>
</head>
<script>
	$(document).ready(function(){
		//listReply2();
		
		var formObj = $("form[name='readForm']");
		
		//수정
		$(".update_btn").on("click", function(){
			if(fn_passChk()){
				return false;
			}
			
			formObj.attr("action", "/board/modifyForm");
			formObj.attr("method", "get");
			formObj.submit();
		});
		//답글
		$(".re_btn").on("click", function(){
			
			formObj.attr("action", "/board/re");
			formObj.attr("method", "get");
			formObj.submit();
		});
		
		//삭제 
		$(".delete_btn").on("click", function(){
			
			if(fn_passChk()){
				return false;
			}
			var deleteYN = confirm("삭제하시겠습니까?");
			
			if(deleteYN == true){
				
			formObj.attr("action", "/board/delete");
			formObj.attr("method", "get");
			formObj.submit();
			
			}
		});

		//목록 
		$(".list_btn").on("click", function(){
			location.href = "/board/list?page=${scri.page}"
			 			  +	"&perPageNum=${scri.perPageNum}"	
						  + "&searchType=${scri.searchType}&keyword=${scri.keyword}";
		});
		//파일다운로드
		$("#file").click(function(){
			alert("파일이 다운로드되었습니다.");
			var bno = $('#bnof').val();
		       var fileName = $("#file").val();
		       var filePath = "C:/hellopt_file/"+ fileName; 
		       console.log("fileName:"+fileName);
		       console.log(filePath);
		       location.href = "/board/download?filePath="+filePath+"&fileName="+fileName;
		    });
	});
	//파일 다운로드
	function download(ori_name,full_name) {
		alert("다운로드"+ori_name);
		alert("다운로드"+full_name);
		var filePath = "C:/hellopt_file/"+full_name;
		var fileName = ori_name;
		location.href = "/board/download?filePath="+filePath+"&fileName="+fileName;
		
	}
	function fn_passChk(){
		var inputPw = prompt('비밀번호를 입력하세요.','');	
		var userPw = '<c:out value= "${view.password}"/>';
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
		//길이체크
		function len_chk(){
		var writer = document.replyForm.writer;
		var pass = document.replyForm.password;
		var content = document.replyForm.content;
		var check = /^(?=.*[a-zA-Z])(?=.*[~`!@#$%?+_\\^&*()-])(?=.*[0-9]).{6,10}$/;
		
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
		$('.counter').html("(" + content.value.length + "/ 최대 300자)" );
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
	
		<header>
			<h1> 게시판</h1>
		</header>
		<hr />
		<div id="btnbox">
			<button type="submit" class="list_btn btn btn-success">목록</button>
			<button type="submit" class="update_btn btn btn-warning">수정</button>
			<button type="submit" class="delete_btn btn btn-danger">삭제</button>
			<button type="submit" class="re_btn btn btn-success">답글</button>
		</div>
		<hr>
		
		
		<section id="container">
			<form name="readForm" role="form" method="post">
			  <input type="hidden" id="bno" name="bno" value="${view.bno}" >
			  <input type="hidden" id="ref" name="ref" value="${view.ref}" >
			  <input type="hidden" id="step" name="step" value="${view.step}" >
			  <input type="hidden" id="lev" name="lev" value="${view.lev}" >
			  <input type="hidden" id="page" name="page" value="${scri.page}"> 
			  <input type="hidden" id="perPageNum" name="perPageNum" value="${scri.perPageNum}"> 
			  <input type="hidden" id="searchType" name="searchType" value="${scri.searchType}"> 
			  <input type="hidden" id="keyword" name="keyword" value="${scri.keyword}"> 
			</form>	

			<div class="whole">
				<div class="form-group">
					<!-- <label for="title" class="wrbox control-label">제목</label> -->
					<h3><c:out value="${view.title }"/></h3>
				</div>
	
				<span class=" form-group">	
					<label for="writer" class="wrbox control-label">작성자 </label>
					<span  id="writer"  class="wrbox" ><c:out value="${view.writer }"/></span>
				</span>
				<span class="wrbox form-group">
					<!-- <label for="regdate" class="gray wrbox control-label">작성날짜</label> -->	
					<span class="gray wrbox"><fmt:formatDate value="${view.regDate }" pattern= "yy.MM.dd HH:mm"/></span>
				</span>
				<br><hr>
				<div class="form-group">
					<c:choose>
					<c:when test="${empty view.b_files }">
					<h4><label>첨부파일<span style="color: yellowgreen;">(0)</span></label></h4>
					</c:when>
					<c:when test="${not empty view.b_files }">
					<c:set var="files" value="${fn:split(view.b_files,'*') }"/>
					<c:set var="file_names" value="${fn:split(view.b_file_names,'*') }"/>
					<h4><label><img alt="파일있음" src="../resources/images/file_icon.png" with="20px;" height="20px;" style="vertical-align: middle;">
						첨부파일<span style="color: yellowgreen;">(${fn:length(files) })</span>
					</label></h4>
					<c:forEach var="files1" items="${files }" varStatus="status">
						<div>
							<label style="margin-right: 10px; cursor: pointer;">
							<button type="button" onclick="download('${file_names[status.index] }','${files1 }')" style="display: none;"></button>
							<img src="../resources/images/download.png" width="20px" height="20px" >
							${file_names[status.index] }</label></div><br>
					</c:forEach>
					</c:when>
					</c:choose>
					<hr>
					<div id="content" style="white-space:pre"><c:out value="${view.content}"/></div>
				</div>
				<hr>
			</div>
			
			<!-- 댓글폼 -->
				<form name="replyForm" method="post" class="form-horizontal">
					<input type="hidden" id="bno" name="bno" value="${view.bno }">
					<input type="hidden" id="page" name="page" value="${scri.page}">
					<input type="hidden" id="perPageNum" name="perPageNum" value="${scri.perPageNum }">
					<input type="hidden" id="searchType" name="searchType" value="${scri.searchType}">
					<input type="hidden" id="keyword" name="keyword" value="${scri.keyword}">
					
					<div class="form-group">
						<!-- <label for="writer"  class="col-sm-2 control-label" >댓글 작성자</label> -->
						<div class="col-sm-10">
							<input type="text" id="rWriter" name="writer" onKeyup="len_chk()" class="chk wpbox" onKeyup="len_chk()" title="작성자를 입력하세요." placeholder="작성자를 입력하세요">
							<span id="counterW">(0 / 최대10자)</span>
							<input type="password" id="rPassword" onKeyup="len_chk()" class="chk wpbox" name="password" onKeyup="len_chk()" maxlength="20" title="비밀번호를 입력하세요 최대10자." placeholder="비밀번호는 영자, 숫자, 특수문자를 포함한6~10자">
							<span id="counterP">(0 / 최대10자)</span>
							</div>
					</div>	
					<div class="form-group ">
						<!-- <label for="content"  class="col-sm-2 control-label">댓글 내용</label> -->
						<div class="col-sm-10">
						<button type="button" class="replyWriteBtn btn btn-success">작성</button>
							<textarea id="rContent" name="content" onKeyup="len_chk()" class="chk form-control" title="내용을 입력하세요." placeholder="댓글내용을 입력하세요."></textarea>
						<span class="counter">(0 / 최대300자)</span>
						</div>
					</div>
						
				</form>
				
				<!--블로그에서 하는 ajax댓글목록  -->
				
				<div class="my-3 p-3 bg-white rounded shadow-sm" style="padding-top: 10px">
					<c:if test="${replycount > 0}">
						<br><br><hr><p>(${replycount}개의 댓글)</p>
					</c:if>
					<div id="replyList"></div>
				</div>
				
				<!--블로그에서 하는 댓글목록  -->
				<div id="reply">
				<ol class="replyList">
					<c:forEach items="${repList }" var="repList">
					<li>
						<p>
						작성자 : <c:out value="${repList.writer }"/> <br>
						작성날짜 :<fmt:formatDate value="${repList.regDate }" pattern="yy.MM.dd HH:mm"/>
						</p>
						<div id ="repl${repList.rno }">
							<p><c:out value="${repList.content }" /></p>
							<div>
								<button type="button" onclick="fn_editReply('${repList.rno}', '${repList.writer }', '${repList.password }', '${repList.content }', '${repList.regDate }')" class=" btn btn-warning" data-rno="${repList.rno}">수정</button>
								<button type="button" onclick="fn_deleteReply('${repList.rno}', '${repList.password }')" class="btn btn-danger" data-rno="${repList.rno}">삭제</button>
							</div>
						</div>
					</li>
					<hr>
					</c:forEach>
				</ol>
			</div>
			</section>
			<div id="inclbox">
					<%@include file="../include/nav.jsp" %>
			</div>
		</div>
	</body>
<script>

	$(".replyWriteBtn").on("click", function(){
		if(fn_valiChk()){
			return false;
		}
		
		var formObj = $("form[name='replyForm']");
		formObj.attr("action", "/board/replyWrite");
		formObj.submit();
	});
/* 	//댓글쓰기 버튼 클릭 이벤트 (ajax로 처리)
	$(document).on("click",".replyWriteBtn", function(){
		console.log("댓글ajax");
		if(fn_valiChk()){
			
			return false;
		}
		
		var bno = ${view.bno};
		var rContent = $('#rContent').val();
		var rWriter = $('#rWriter').val();
		var rPassword = $('#rPassword').val();
		console.log(bno)
		console.log(rContent)
		console.log(rWriter)
		console.log(rPassword)
		$.ajax({
			type:"POST",
			url: "/reply/insert",
			headers:{"Content-Type" : "application/json"},
			data: JSON.stringify({
				"bno": bno,
				"content" : rContent,
				"writer" : rWriter,
				"password" : rPassword
			}),
			dataType: 'text',
			success: function(){
				listReply2();
				$('#rContent').val('');
				$('#rWriter').val('');
				$('#rPassword').val('');

				alert("댓글이 등록되었습니다.");
			}, error: function(error){
				console.log("에러:" + error);
			}
		})

	}) */
/* 	function listReply2(){
		console.log("리스트2");
		var paramData = {"bno" : "${view.bno}"};
	$.ajax({
		type: "post",
		//contentType: "application/json", ==>생략가능 (RestController가 )
		url: "/reply/list",
		data: paramData,
		success:function(result){
			console.log(result);
				var output = "";
			if(result.length > 0){
					output = "<div id='reply'>";
					output = "<ol class='listReply'>";
				for(var i in result){
					output +="<li id='repl"+result[i].rno+"'>";
					output +="<p>작성자:"+result[i].writer;
					output +="<br>(" +changeDate(result[i].regDate)+")</p><br>";
					output += "<p style='white-space:pre-wrap;'>"+result[i].content +"</p><br>";
					output +="<div>";
					output +='<a href="javascript:void(0)" onclick="fn_editReply(' + result[i].rno + ', \'' + result[i].writer + '\',\'' + result[i].password + '\', \'' + result[i].content + '\', \''+ result[i].regDate + '\')" style="padding-right:5px">수정</a>';
					output +='<a href="javascript:void(0)" onclick="fn_deleteReply(' + result[i].rno + ', \''+ result[i].password+ '\')" >삭제</a>';
					output +="<hr></div>";
					output +="</li>";
				}
					output +="</ol>";
					output +="</div>";
				}else{
					output += "<hr>등록된 댓글이 없습니다.<hr>";
				}
			
			$("#replyList").html(output);
		}
	}); 
} */
	
	//수정폼
	   function fn_editReply(rno, writer, password, content, regDate){
		   if(r_passChk(password)){
				return false;
			}
	  		var output = "";
	  		
			//output +="<li id='repl"+rno+"'>";
			//output +="<p>작성자: " + writer;
			//output +="<br>("+changeDate(regDate)+")</p><br>";
			output +="<textarea rows='2' cols='80' onKeyup='len_chk2(this)' name='ajaxcontent' id='ajaxcontent'>"+content +"</textarea><br>";
			output +="<span class='counter'>(0 / 최대300자)</span>";
			output +="<div>";
			output +='<a class="btn btn-warning" href="javascript:void(0)" onclick="fn_updateReply(' + rno + ', \'' + writer + '\',\''+password+'\')" style="margin-right:3px">저장</a>';
			output +='<a class="btn btn-danger" href="javascript:void(0)" onclick="listReply2()" >취소</a>';
			output +="<hr></div>";
			output +="</li>";

			$("#repl"+rno).html(output);
			var contentvalue = $("#ajaxcontent").val();
			$("#ajaxcontent").focus();
			$('.counter').html("(" + content.length + "/ 최대 300자)" );
	   } 
		function len_chk2(target){
			var content = target.value;
			
			
			if(content.length >300){
				alert("글자수는 300자로 제한됩니다.");
				content = content.substring(0, 300);
			}	
			$('.counter').html("(" + content.length + "/ 최대 300자)" );
		}

	   
		function fn_updateReply(rno){
			   alert("수정처리");
			   var repleEditContent =$('#ajaxcontent').val();
			   console.log(repleEditContent);
			   var paramData = JSON.stringify({"content":repleEditContent, "rno":rno});
			   console.log(paramData);
				$.ajax({
					url:"/reply/update",
					type:"post",
					data: paramData,
					contentType: "application/json",//이걸 해줘야 컨트롤러를 찾아감
					success:function(result){
						console.log(result);
						alert("수정완료");
						window.location.reload();
					}
					,error: function(error){
						console.log("에러:" + error);
					}
				})
		}
		function fn_deleteReply(rno, password){
			if(confirm("삭제 하시겠습니까?")){
				if(r_passChk(password)){
					return false;
				}
		   var paramData = JSON.stringify({'rno':rno});
			$.ajax({
			   url:"/reply/delete",
				type:"post",
				data:paramData,
				dataType : 'text',
				contentType:"application/json",
				success:function(result){
					alert("삭제되었습니다.");
					window.location.reload();
				}
		   		,error:function(error){
		   			console.log("에러:" + error);
		   		}
		   })
		}
   }
		function r_passChk(password){
			var inputPw = prompt('비밀번호를 입력하세요.','');	
			if(inputPw == null){
				return true;
			}
			if(inputPw == password){
				return false;
			}else{
				alert("비밀번호가 일치하지 않습니다.");
			return true;
			}
		}
		function changeDate(String){
			console.log(String);
			date = new Date(String);
			console.log("date:"+date);
			
			year = date.getFullYear();
			month = date.getMonth();
			day = date.getDate();
			hour = date.getHours();
			minute = date.getMinutes();
			second = date.getSeconds();
			strDate = year+"."+month+"."+day+" "+hour+":"+minute+ ":"+second;
			
			console.log("strDate:"+strDate);
			return strDate;
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
</html>
