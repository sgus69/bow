package com.bow.domain;

import java.util.List;

public class Criteria {
//rNum을 제한하는 값중 시작값은 #{rowStart}, 끝값은 #{rowEnd}로 했으며
//파라미터 타입(parameterType)을 Criteria로 했습니다.
//Criteria는 시작값과 끝값을 다루는 클래스다.
	
	
	private int page; //현재 페이지 번호
	private int perPageNum; //페이지당 보여줄 게시글의수
	private int rowStart;//페이지 한 행의 첫번째 게시물 rowNum
	private int rowEnd;//페이지 한 행의 마지막 게시물 rowNum
	private List<FileVO> filevo;//파일정보 객체 주입 
	

	public Criteria() {//디폴트 생성자
		//최초 게시판에 진입할 때를 위한 기본값 설정
		this.page = 1; //페이지 1로 초기화
		this.perPageNum = 10; //페이지당 게시글 10개
	}
	
	public void setPage(int page) {//페이지 번호 set
		if (page <= 0) {
			this.page = 1;
			return;
		}
		this.page = page;
	}
	
	public void setPerPageNum(int perPageNum) {
		//페이지당 게시물 갯수 set
		if (perPageNum <= 0 || perPageNum > 100) {
			this.perPageNum = 10;
			return;
		}
		this.perPageNum = perPageNum;
	}
	
	public int getPage() {
		return page;
	}
	
	public int getPageStart() {
		//현재 페이지의 페이지당 게시글 수를 곱하여
		//현재 페이지의 시작 게시글 RowNum수를 구하는것 = 특정 페이지의 시작 게시글 번호
		return (this.page - 1) * perPageNum;
	}
	
	public int getPerPageNum() {
		return this.perPageNum;
	}
	
	public int getRowStart() {
		rowStart = ((page - 1) * perPageNum) + 1;
		return rowStart;
	}
	
	public int getRowEnd() {
		rowEnd = rowStart + perPageNum - 1;
		return rowEnd;
	}

	@Override
	public String toString() {
		return "Criteria [page=" + page + ", perPageNum=" + perPageNum + ", rowStart=" + rowStart + ", rowEnd=" + rowEnd
				+ "]";
	}

	
}
