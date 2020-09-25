<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style type="text/css">
	li {list-style: none; display:inline; padding: 6px;}
	ol, ul {
	
    margin-top: 10px;
    margin-bottom: 10px;
    }
    #navul{
    padding-inline-start: 5px;
    margin-bottom: 100px;
    }
    
</style>
<ul id="navul">
	<!-- <li>
		<a href="/board/listPage?num=1">글 목록(페이징)</a>
	</li> -->
	<li id = "list_btn">
		<a href="/board/list">최신목록</a>
	</li>

	<li>
		<a href="/board/write">글쓰기</a>
	</li>

</ul>