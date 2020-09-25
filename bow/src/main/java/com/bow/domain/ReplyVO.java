package com.bow.domain;

import java.util.Date;

import javax.validation.constraints.Pattern;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


@Data
@AllArgsConstructor
@NoArgsConstructor
public class ReplyVO {

	private int bno;
	private int rno;
	private String content;
	private String writer;
	private String password;
	private Date regDate;
	
}
	
	