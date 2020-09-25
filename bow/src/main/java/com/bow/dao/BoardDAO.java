package com.bow.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.bow.domain.BoardVO;
import com.bow.domain.Criteria;
import com.bow.domain.FileVO;
import com.bow.domain.SearchCriteria;

public interface BoardDAO {
	
	public List<BoardVO> list(SearchCriteria scri) throws Exception; //게시물 목록
	
	public List<BoardVO> searchlist(SearchCriteria scri) throws Exception; //게시물 목록
	
	public List<BoardVO> list() throws Exception; //게시물 전체목록
	
	public int listCount(SearchCriteria scri) throws Exception; //게시물 총 갯수
	
	public int refCount(int ref) throws Exception; //ref 총 갯수
	
	public int write(BoardVO vo) throws Exception; //게시물작성
	
	public void insertFile(Map<String, Object> map) throws Exception; //첨부파일업로드
	
	public void ndelgbFiel(int fno) throws Exception; //파일삭제여부 n으로변경
	
	public void ydelgbFiel(int bno) throws Exception;//파일삭제여부y로 변경 
	
	public void deleteFile(int fno) throws Exception; //파일삭제
	
	public List<FileVO> getFileList(int bno)throws Exception; //파일저장명찾아옴
	
	public List<FileVO> getFileInfo(int bno)throws Exception; //파일저장명찾아옴

	public BoardVO view(int bno) throws Exception; //게시물 조회
	
	public void modify(BoardVO vo) throws Exception; //게시물 수정
	
	public void isdelete(int bno) throws Exception; //게시물 y를 n으로 변경
	
	public void delete(int bno) throws Exception; //게시물 찐삭제
	
	public void viewCnt(int bno) throws Exception; //조회수 증가
	
	public int getRefMax() throws Exception; // 최상위부모글 순번 생성
	
	//같은 REF(최상위부모값)을 가진 것 중 현재 답글을 달 게시물의 순번보다 큰것을 +1로 하여 하나씩 밀리게한다 
	public int updateStep(BoardVO vo) throws Exception;
	
	public int getStepMax(BoardVO vo) throws Exception; // 현재답글의 순번 생성

	public int reWrite(BoardVO vo) throws Exception; // 답글 작성
}