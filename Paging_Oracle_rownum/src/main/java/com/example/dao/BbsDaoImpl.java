package com.example.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.vo.BbsVO;

@Repository
public class BbsDaoImpl implements BbsDao {
	@Autowired
	private SqlSession sqlSession;
	@Override
	public List<BbsVO> selectAll(Map<String, Object> map) {
		return this.sqlSession.selectList("Bbs.selectAll", map);
	}
	//전체 페이지의 갯수를 가져온다.
	@Override
	public int getTotolCount() {
		return (Integer)this.sqlSession.selectOne("Bbs.selectCount");
	}
}
