package com.example.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.dao.HomeDao;
import com.example.vo.HomeVO;

@Service("homeService")
public class HomeServiceImpl implements HomeService {
	@Autowired
	private HomeDao homeDao;

	@Override
	public List<HomeVO> readAll() {
		List<HomeVO> list = this.homeDao.selectAllHome();
		list.forEach(qna -> {
			String title  = qna.getTitle();
			title = this.reverseChangeTag(title);
			title = title.replace("\"", "'");
			qna.setTitle(title);
		});
		return this.homeDao.selectAllHome();
	}

	private String changeEnter(String str) {
		String str1 = str.replace("\n", "<br />");
		
		return str1;
	}

	private String changeTag(String str) {
		String newStr = str.replace("<", "&lt;");
		return newStr.replace(">", "&gt;");
	}
	
	private String reverseChangeEnter(String str) {
		String str1 = str.replace("<br />\\", "\n");
		
		return str1;
	}

	private String reverseChangeTag(String str) {
		String newStr = str.replace("&lt;", "<");
		return newStr.replace("&gt;", ">");
	}

	@Override
	public int getTotalPage(int pageSize) {
		int count = this.homeDao.getTotolCount();	//질문 게시판 전체 레코드 수
		int totalPage = 0;
		if(count % pageSize == 0) {
			//정확이 떨어진다면
			totalPage = count / pageSize;
		}else totalPage = count / pageSize + 1;	//아니라면 전체 페이지에 +1
		return totalPage;
	}

}
