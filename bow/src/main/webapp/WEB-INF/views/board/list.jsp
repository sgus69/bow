<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="now" class="java.util.Date"/>
<!DOCTYPE html>
<html>
<head>
<!-- 부트스트랩 css 사용 -->
<!-- 합쳐지고 최소화된 최신 CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<!-- 부가적인 테마 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">
<script src="//code.jquery.com/jquery-1.11.3.min.js"></script>
<script src="//code.jquery.com/jquery-migrate-1.2.1.min.js"></script>
<meta charset="UTF-8">
<style>
	.table>tbody>tr>td, .table>tbody>tr>th, .table>tfoot>tr>td, .table>tfoot>tr>th, .table>thead>tr>td, .table>thead>tr>th{
	padding:14px;
	}
	.col-sm-2 {
	    width: auto;
	}
	.search row{
	display: inline-flex;
	}
	.col-xs-10 {
    display: inline-flex;
	}
	.retext{
		float:left;
	}
	.titletd{
	
		width:550px;
	}
	
	th, td{
		text-align: center;
	}	
	#titlea {
		display:inline-block;
		text-overflow: ellipsis;
		overflow:hidden;
		white-space: nowrap;
		text-align: left;
		margin: 0 0 0px;
		width: auto;
    	max-width: 500px;
		float: left;
	}
	img { 
		float: left;
		margin-left: 5px;
	}
	#recnt{
		color:red; 
		float:left;
		margin-left: 5px;
	}
	#writerhead{
		width:170px;
	}
	#titlebox{
	text-overflow: ellipsis;
		overflow:hidden;
	}	
</style>
<title>게시물 목록</title>
</head>

<body>
<div class="container">
			<header>
				<h1> 게시판</h1>
			</header>
			<hr />
	<div id="nav">
		<%@ include file="../include/nav.jsp" %>
	</div>
<section id="container">
<form role="from" method="get">
	<div>
		${pageMaker.totalCount} 개의 게시물이 있습니다.
	</div>
		<a href="/board/excel${pageMaker.makeSearch(scri.page)}">엑셀다운</a>
		<br>
		<a href="/board/excelall${pageMaker.makeSearch(scri.page)}">엑셀전체목록다운</a>
	<table class="table table-hover">
		<thead>
			<tr>
				<th width="100">번호</th>
				<th id="titlehead" width="100">제목</th>
				<th id="writerhead" width="150">작성자</th>
				<th width="150">작성일</th>
				<th width="100">조회수</th>
			</tr>
		</thead>
		<tbody>
			<fmt:formatDate var="today" value="${now }" pattern="yy.MM.dd" />
			
			<c:set var="num" value="${pageMaker.totalCount -((scri.page -1)*10)}"/>
			<c:forEach items="${list }" var="list">
					<tr>
						<td>${num}</td>
					<c:choose>
						<c:when test="${list.show == 'y' }">
						<td class="titletd">
						<div id  = "titlebox">
								<span class="retext">
								<!-- 제목 -->
								<!-- 1레벨 당 2칸씩 띄기 -->
									<c:forEach var="sp" begin="1" end="${list.lev}">
										&nbsp;&nbsp;
									</c:forEach>
									<!-- 답글인 경우 re이미지 출력 -->
									<c:if test="${list.lev >0 }">
										└>
										<c:forEach var="re" begin="1" end="${list.lev}">
											Re:
										</c:forEach>
									</c:if>
									<!-- 답글인 경우 re이미지 출력 끝-->
								</span><a id="titlea" href="/board/view?bno=${list.bno }&
												page=${scri.page}&
												perPageNum=${scri.perPageNum}&
												searchType=${scri.searchType}&
												keyword=${scri.keyword}">
									<c:out value="${list.title }"/>
								</a>
								<!-- 제목안에 파일유무-->
								<c:if test="${not empty list.b_files}">
									<img alt="파일있음" src="../resources/images/file_icon.png" with="16px;" height="16px;" style="vertical-align: middle;">						
								</c:if>
								<!-- 제목안에  파일유무 끝-->
								<!-- 제목안에 댓글수 -->
								<c:if test="${list.recnt > 0 }">
									<span id = "recnt"><c:out value="(${list.recnt })"/></span>							
								</c:if>
								<!-- 제목안에 댓글수 끝-->
							</div>
						</td>
						
						<!-- 제목끝 -->
						<td><c:out value="${list.writer }"/></td>
						<td class="regDate">
						<fmt:formatDate var="regDate" value="${list.regDate }" pattern="yy.MM.dd HH:mm"/>
						<c:choose>
							<c:when test="${today eq regDate }">
								<fmt:formatDate value="${list.regDate }" pattern="HH:MM"/>
							</c:when>
							<c:otherwise>
								<c:out value="${regDate }"/> 
							</c:otherwise>
						</c:choose>
						
						</td>
						<td>${list.viewCnt }</td>
					</c:when>
					<c:otherwise>
						<td colspan="4" style="text-align:left;">
						<span class="retext">
								<!-- 제목 -->
								<!-- 1레벨 당 2칸씩 띄기 -->
									<c:if test="${list.lev >0 }">
										<c:forEach var="sp" begin="1" end="${list.lev}">
											&nbsp;&nbsp;
										</c:forEach>
											└>
									<!-- 답글인 경우 re이미지 출력 -->
										<c:forEach var="re" begin="1" end="${list.lev}">
											Re:
										</c:forEach>
										
									</c:if>
									<!-- 답글인 경우 re이미지 출력 끝-->
								</span>삭제된 게시물입니다.
						</td>
					</c:otherwise>
				</c:choose>
					</tr>
					
					<c:set var="num" value="${num-1 }"></c:set>
			</c:forEach>
		</tbody>
	</table>
	<div class="search row">
		<div class="col-xs-2 col-sm-2">
			<select name="searchType" class="form-control">
				<option value="t" <c:out value="${scri.searchType eq 't' ? 'selected' : '' }"/>>제목</option>
				<option value="c" <c:out value="${scri.searchType eq 'c' ? 'selected' : '' }"/>>내용</option>
				<option value="w" <c:out value="${scri.searchType eq 'w' ? 'selected' : '' }"/>>작성자</option>
				<option value="tc" <c:out value="${scri.searchType eq 'tc' ? 'selected' : '' }"/>>제목+내용</option>
			</select>
		</div>
		<div class="col-xs-10 col-sm-10">
			<div class="input-group">
				<input type = "text" name="keyword" id="keywordInput" value="${scri.keyword }" class="form-control">
				<span class="input-group-btn">
					<button id="searchBtn" type="button" class="btn btn-default">검색</button>
				</span>
			</div>
		</div>
		
		<script>
	      $(function(){
	        $('#searchBtn').click(function() {
	          self.location = "list" + '${pageMaker.makeQuery(1)}' + "&searchType=" + $("select option:selected").val() + "&keyword=" + encodeURIComponent($('#keywordInput').val());
	        });
	      });   
    	</script>
	</div>
	
				<div class="col-md-offset-3">
				  	<ul class="pagination">
				  			<li><a href="list${pageMaker.makeSearch(1)}">처음</a></li>
					    <c:if test="${pageMaker.prev}">
					    	<li><a href="list${pageMaker.makeSearch(pageMaker.startPage - 1)}">이전</a></li>
					    </c:if> 
					
					    <c:forEach begin="${pageMaker.startPage}" end="${pageMaker.endPage}" var="idx">
					    	<li <c:out value="${pageMaker.cri.page == idx ? 'class=active' : ''}" />>
					    		<a href="list${pageMaker.makeSearch(idx)}">${idx}</a>
					    	</li>
					    </c:forEach>
					
					    <c:if test="${pageMaker.next && pageMaker.endPage > 0}">
					    	<li><a href="list${pageMaker.makeSearch(pageMaker.endPage + 1)}">다음</a></li>
					    </c:if> 
					    	<li><a href="list${pageMaker.makeSearch(pageMaker.tempEndPage)}">끝</a></li>
	  				</ul>
				</div>
			</form>
		</section>	
		</div>
	<!--  부트스트랩 js 사용 -->
	</body>
</html>