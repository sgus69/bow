package com.bow.domain;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class FileVO {
	private int fno;//파일시퀀스넘버
	private int bno;//보드시퀀스넘버
	private String oname;//파일 원래이름
	private String sname;//파일 저장이름
	private long fsize;//파일 사이즈
	private Date regDate;//올린날짜
	private String delGb;//삭제여부
}
