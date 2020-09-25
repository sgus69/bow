package com.bow.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.bow.domain.BoardVO;
import com.bow.domain.Criteria;
import com.bow.domain.FileVO;
import com.bow.domain.SearchCriteria;

public interface BoardService {

	public List<BoardVO> list(SearchCriteria scri)throws Exception;//게시물 목록

	public List<BoardVO> searchlist(SearchCriteria scri)throws Exception;//게시물 목록

	public List<BoardVO> list()throws Exception;//게시물 목록
	
	public int listCount(SearchCriteria scri) throws Exception;//게시글 총 갯수
	
	public int refCount(int ref) throws Exception;//게시글 총 갯수
	
	public int  write(BoardVO vo, MultipartHttpServletRequest req)throws Exception;//게시물 작성
	
	public BoardVO view(int bno) throws Exception; //게시물 조회
	
	public void modify(BoardVO vo, MultipartHttpServletRequest req) throws Exception; //게시물 수정
	
	public void isdelete(int bno) throws Exception; //게시물 y를 n으로 변경
	
	public void delete(int bno) throws Exception; //게시물 삭제
	
	public int  reWrite(BoardVO vo, MultipartHttpServletRequest req)throws Exception;//답글 작성
	
	//등록 전 요소 업데이트
	public int stepup(HttpServletRequest request)throws Exception;
	
	public void insertFile(String oname, String sname, long fsize, int bno)throws Exception;//파일업로드
	public void updateFile(BoardVO vo, MultipartHttpServletRequest req) throws Exception;
	public void ndelgbFile(int fno)throws Exception;//파일삭제여부n으로 바꿔주기
	public void ydelgbFile(int bno)throws Exception;//파일삭제여부 y로 변경
	public void deleteFile(int fno)throws Exception;//파일삭제
	public List<FileVO>getFileList(int bno)throws Exception;//파일명 리스트
	public List<FileVO> getFileInfo(int bno)throws Exception;//파일정보

	
	
}
