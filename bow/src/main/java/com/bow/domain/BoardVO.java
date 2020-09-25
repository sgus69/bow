package com.bow.domain;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import javax.validation.constraints.Pattern;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;


@Data
@AllArgsConstructor
@NoArgsConstructor
public class BoardVO {
	private int rNum;
	private int bno;//보드 시퀀스 넘버
	private String title;//제목
	private String content;//내용
	private String writer;//작성자
	private Date regDate;//작성날짜
	private Date updateDate;
	private int viewCnt;//조회수
	private String password;//비밀번호
	private int recnt;//댓글수
	private String show; //게시글 삭제 유무(y, n)
	private int filecnt;//파일갯수
	private String b_files; //게시글 삭제 유무(y, n)
	private String b_file_names; //게시글 삭제 유무(y, n)
	
	//계층형 게시판을 위한 추가 필드
	private int ref;//그룹번호=원글 번호
	private int step;//원글(답글포함)에 대한 순서
	private int lev;//답글 계층
}
