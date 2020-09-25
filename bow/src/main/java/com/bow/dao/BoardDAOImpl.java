package com.bow.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.bow.domain.BoardVO;
import com.bow.domain.Criteria;
import com.bow.domain.FileVO;
import com.bow.domain.SearchCriteria;

@Repository
public class BoardDAOImpl implements BoardDAO {
	
	private static Logger logger =LoggerFactory.getLogger(BoardDAOImpl.class);
	
	@Inject
	private SqlSession sql;
	
	private static String namespace = "com.bow.mappers.board";
	
	//게시물 목록 페이징 처리
	@Override
	public List<BoardVO> list(SearchCriteria scri) throws Exception {
		return sql.selectList(namespace+".listPage", scri);
	}
	//게시물 목록 페이징 처리
	@Override
	public List<BoardVO> searchlist(SearchCriteria scri) throws Exception {
		return sql.selectList(namespace+".searchlist", scri);
	}
	//전체 게시물
	@Override
	public List<BoardVO> list() throws Exception {
		return sql.selectList(namespace+".list");
	}

	
	@Override
	public int listCount(SearchCriteria scri) throws Exception {
		return sql.selectOne(namespace+".listCount", scri);
	}
	//글쓰기
	@Override
	public int write(BoardVO vo) throws Exception {
		return sql.insert(namespace + ".write", vo);
	}
	
	//첨부파일
	@Override
	public void insertFile(Map<String, Object> map) throws Exception {
		sql.insert(namespace + ".insertFile", map);
	}

	@Override
	public BoardVO view(int bno) throws Exception {
		return sql.selectOne(namespace+".view", bno);
	}
	//글수정하기
	@Override
	public void modify(BoardVO vo) throws Exception {
		sql.update(namespace +".modify", vo);
		
	}
	
	@Override
	public void isdelete(int bno) throws Exception {
		sql.delete(namespace+".isdelete", bno);
	}
	
	@Override
	public void delete(int bno) throws Exception {
		sql.delete(namespace+".delete", bno);
	}

	@Override
	public void viewCnt(int bno) throws Exception {
		sql.update(namespace+".viewCnt", bno);
	}

	@Override
	public int getRefMax() throws Exception {
		return sql.selectOne(namespace + ".getRefMax");
	}

	@Override
	public int updateStep(BoardVO vo) throws Exception {
		return sql.update(namespace + ".updateStep", vo);
	}
	
	@Override
	public int getStepMax(BoardVO vo) throws Exception {
		return sql.selectOne(namespace + ".getStepMax", vo);
	}
	@Override
	public int reWrite(BoardVO vo) throws Exception {
		logger.info("답글작성daoimpl invoked...");
		sql.insert(namespace+ ".insertReplyBoard", vo);
		
		 int bno = vo.getBno();
		  return bno;  
	}

	@Override
	public int refCount(int ref) throws Exception {
		return sql.selectOne(namespace + ".refCount", ref);
	}

	//파일 삭제여부 바꿔주기
	@Override
	public void ndelgbFiel(int fno) throws Exception {
		sql.update(namespace + ".ndeleteFile", fno);
	}
	//파일 삭제
	@Override
	public void deleteFile(int fno) throws Exception {
		sql.delete(namespace + ".deleteFile", fno);
	}

	@Override
	public List<FileVO> getFileList(int bno) throws Exception {
		return sql.selectList(namespace+".getFileList", bno);
	}

	@Override
	public List<FileVO> getFileInfo(int bno) throws Exception {
		return sql.selectList(namespace+".getFileInfo", bno);
	}
	//파일 삭제여부 변경y로
	@Override
	public void ydelgbFiel(int bno) throws Exception {
		sql.update(namespace+".ydeleteFile", bno);
		
	}



	



}
