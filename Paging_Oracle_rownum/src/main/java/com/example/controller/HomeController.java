package com.example.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.service.BbsService;
import com.example.vo.BbsVO;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class HomeController {
	@Autowired
	private BbsService bbsService;
	@GetMapping("/list")
	public String boardView(Model model, @RequestParam(value = "page") String currentPage) {
		/*Var*/
		List<BbsVO> list = null;	
		/*page 계산*/
		//1. 현재페이지: page, 쿼리스트링으로 값이 들어오지 않으면 1페이지로, 들어왔으면 String 처리
		int page = (currentPage == null) ? 1:Integer.parseInt(currentPage);
		
		//2. 전체 게시물수: totalBbs: mapper에서 받아온다. 필요한 페이지 수를 구하기 위함
		int totalBbs = this.bbsService.getTotolCount();
		
		//3. 한 페이지에 보여줄 게시물 수
		int countList = 10;
		
		//4. 한 화면에 보여줄 페이지의 수: countPage
		int countPage = 10;
		
		//5. 전체 페이지 수 totalPage: (totalBbs / countList), 
		//만약 계산 결과 나머지가 0이라면 이상 X, 그러나 나머지가 있다면 해당 페이지에 +1을 해야 맞다.
		int testExp = (totalBbs % countList);
		System.out.println("나머지:" + testExp);
		int totalPage = ( testExp == 0 ) ? (totalBbs / countList):(totalBbs / countList)+1;
		System.out.println("총 페이지:" + totalPage);
		
		//6-1. 시작페이지: startPage = ((page - 1) / countPage) * countPage + 1
		int startPage = ((page - 1) / countPage) * countPage + 1;
		//6-2. 끝 페이지: endPage =  startPage + countPage - 1
		//단 이 공식은 현재 페이지가 끝 페이지일 경우 문제가 발생: 26page가 마지막인데, 21 + 10 - 1: 30page가 마지막
		//따라서 현제 페이지가 마지막 페이지일 경우 endPage는 lastPage
		int endPage =  startPage + countPage - 1;
		if(page > totalPage) endPage = totalPage; 
		System.out.println("startPage:" + startPage);
		System.out.println("endPage:" + endPage);
		//7. 현제 페이지의 rownum 구하기
		/* countList가 10
		 * 2페이지면 11 ~ 20
		 * startBbs: (page-1) * totalBbs + 1, 현재 페이지가 2라면 1 * 10 + 1, 
		 * - - 3페이지의 경우 21 ~ 30이기 때문에 +1 page - 1, 페이지의 시작은 X1부터 시작이므로 +1
		 * ednBbs: (page-1) * totalBbs + toalBbs
		 * */
		//7-1. 한 페이지의 첫 게시물 startBbs = (page-1) * totalBbs + 1
		int startBbs = (page-1) * countList + 1;
		//7-2. 한 페이지의 끝 게시물 endBbs = (page-1) * totalBbs + totalBbs
		int endBbs = (page-1) * countList + countList;
		/*request & response*/
		/*
		 * Request 
		 * - page: RequestParam, 현재 페이지
		 * Response
		 * - bbsList: 게시물 정보
		 * - startPage: 시작 페이지 출력 정보 
		 * - endPage: 끝 페이지 출력 정보
		 * - totalPage: 전체 페이지
		 */
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("startBbs", startBbs);
		map.put("endBbs", endBbs);
		System.out.println("시작값:" + startBbs);
		System.out.println( "끝값:" + endBbs);
		list = this.bbsService.selectAll(map);
		model.addAttribute("currentPage", page);
		model.addAttribute("bbsList", list);
		model.addAttribute("startPage", startPage);
		model.addAttribute("endPage", endPage);
		model.addAttribute("totalPage", totalPage);
		return "list";
	}
}
