package com.kiy.wcms.entrepot.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kiy.wcms.Global;
import com.kiy.wcms.entrepot.entity.Entrepot;
import com.kiy.wcms.entrepot.entity.EntrepotLog;
import com.kiy.wcms.entrepot.entity.EntrepotParam;
import com.kiy.wcms.entrepot.entity.Shelf;
import com.kiy.wcms.entrepot.entity.WarningSetting;
import com.kiy.wcms.entrepot.service.EntrepotService;
import com.kiy.wcms.sys.entity.SysUser;
import com.kiy.wcms.util.AjaxUtil;

@Controller
@RequestMapping("/entrepot/")
public class EntrepotController {
	@Autowired
	private EntrepotService entrepotService;
	
	/**
	 * 跳转入库页面
	 * @return
	 */
	@RequestMapping("entrepotIn")
	public String entrepotIn(){
		return "/app/entrepot/entrepot_entering_list";
	}
	
	/**
	 * 跳转出库页面
	 * @return
	 */
	@RequestMapping("entrepotOut")
	public String entrepotOut(){
		return "/app/entrepot/entrepot_outing_list";
	}
	
	/**
	 * 跳转库存查询页面
	 * @return
	 */
	@RequestMapping("entrepotQuery")
	public String entrepotQuery(){
		return "/app/entrepot/entrepot_query";
	}
	
	/**
	 * 跳转库存预警设置页面
	 * @return
	 */
	@RequestMapping("entrepotWarring")
	public String entrepotWarring(){
		return "/app/entrepot/entrepot_num_set";
	}
	
	@RequestMapping("warningQuery")
	public String warningQuery(){
		return "/app/entrepot/entrepot_warning_query";
	}
	
	/**
	 * 跳转到仓库配置页面
	 * @return
	 */
	@RequestMapping("entrepotSettings")
	public String entrepotSettings(){
		
		return "/app/entrepot/entrepot_settings";
	}
	
	/**
	 * 跳转到货架配置页面
	 * @return
	 */
	@RequestMapping("shelfSettings")
	public String shelfSettings(){
		return "/app/entrepot/shelf_settings";
	}
	
	/**
	 * 获取仓库列表
	 * @param response
	 */
	@RequestMapping("getEntrepotList")
	public void getEntrepotList(Integer page, Integer rows, HttpServletResponse response){
		if(page==null){
			page = 1;
		}
		if(rows==null){
			rows = 10;
		}
		int begin = (page-1)*rows;
		JSONObject json = entrepotService.getEntrepotList(begin, rows);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 新增仓库
	 * @param entrepot
	 * @param response
	 */
	@RequestMapping("addEntrepot")
	public void addEntrepot(Entrepot entrepot, HttpServletResponse response){
		boolean flag = entrepotService.addEntrepot(entrepot);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 更新仓库
	 * @param entrepot
	 * @param response
	 */
	@RequestMapping("updateEntrepot")
	public void updateEntrepot(Entrepot entrepot, HttpServletResponse response){
		boolean flag = entrepotService.updateEntrepot(entrepot);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 获取仓库树结构
	 * @param response
	 */
	@RequestMapping("getEntrepotTree")
	public void getEntrepotTree(HttpServletResponse response){
		JSONArray array = entrepotService.getEntrepotTree();
		AjaxUtil.outputJsonArray(response, array);
	}
	
	/**
	 * 更具仓库获取货架列表
	 * @param page
	 * @param rows
	 * @param eid  仓库ID
	 * @param response
	 */
	@RequestMapping("getShelfsByEid")
	public void getShelfsByEid(Integer page, Integer rows, String eid, HttpServletResponse response){
		if(page == null){
			page = 1;
		}
		if(rows == null){
			rows = 10;
		}
		int begin = (page-1)*rows;
		JSONObject json = entrepotService.getShelfsByEid(begin, rows, eid);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 新增货架
	 * @param shelf
	 * @param response
	 */
	@RequestMapping("addShelf")
	public void addShelf(Shelf shelf, HttpServletResponse response){
		boolean flag = entrepotService.addShelf(shelf);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 更新货架
	 * @param shelf
	 * @param response
	 */
	@RequestMapping("updateShelf")
	public void updateShelf(Shelf shelf, HttpServletResponse response){
		boolean flag = entrepotService.updateShelf(shelf);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 删除货架
	 * @param id
	 * @param response
	 */
	@RequestMapping("deleteShelf")
	public void deleteShelf(String id, HttpServletResponse response){
		boolean flag = entrepotService.deleteShelf(id);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 根据仓库获取所有货架
	 * @param eid
	 * @param response
	 */
	@RequestMapping("getAllShelfsByEid")
	public void getAllShelfsByEid(String eid, HttpServletResponse response){
		JSONArray array = entrepotService.getAllShelfsByEid(eid);
		AjaxUtil.outputJsonArray(response, array);
	}
	
	/**
	 * 入库
	 * @param log
	 * @param response
	 */
	@RequestMapping("inEntrepot")
	public void inEntrepot(EntrepotLog log, HttpServletResponse response, HttpServletRequest request){
		SysUser user = (SysUser) request.getSession().getAttribute(Global.LOGIN_USER);
		log.setCode(entrepotService.getNextInEntrepotCode());
		log.setCreateTime(System.currentTimeMillis());
		log.setCreateUser(user.getId());
		boolean flag = entrepotService.inEntrepot(log);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 获取入库记录列表
	 * @param page
	 * @param rows
	 * @param param
	 * @param response
	 */
	@RequestMapping("getInEntrepotList")
	public void getInEntrepotList(Integer page, Integer rows, 
			EntrepotParam param, HttpServletResponse response){
		if(page == null){
			page = 1;
		}
		if(rows == null){
			rows = 10;
		}
		int begin = (page-1) * rows;
		param.setBegin(begin);
		param.setRows(rows);
		
		JSONObject json = entrepotService.getInEntrepotList(param);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 获取库存物品
	 * @param tid
	 * @param response
	 */
	@RequestMapping("getGoodsStockByTid")
	public void getGoodsStockByTid(Integer page, Integer rows, String tid, 
			String name, String code, String model, String brand, HttpServletResponse response){
		if(page == null){
			page = 1;
		}
		if(rows == null){
			rows = 10;
		}
		int begin = (page - 1) * rows;
		
		JSONObject json = entrepotService.getGoodsStockByTid(begin, rows, tid, name, code, model, brand);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 出库
	 * @param log
	 * @param request
	 * @param response
	 */
	@RequestMapping("outEntrepot")
	public void outEntrepot(EntrepotLog log, HttpServletRequest request, HttpServletResponse response){
		SysUser user = (SysUser) request.getSession().getAttribute(Global.LOGIN_USER);
		log.setCreateTime(System.currentTimeMillis());
		log.setCreateUser(user.getId());
		log.setType(1);
		log.setCode(entrepotService.getNextOutEntrepotCode());
		
		boolean flag = entrepotService.outEntrepot(log);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 获取出库记录列表
	 * @param page
	 * @param rows
	 * @param param
	 * @param response
	 */
	@RequestMapping("getOutEntrepotList")
	public void getOutEntrepotList(Integer page, Integer rows, 
			EntrepotParam param, HttpServletResponse response){
		if(page == null){
			page = 1;
		}
		if(rows == null){
			rows = 10;
		}
		int begin = (page-1) * rows;
		param.setBegin(begin);
		param.setRows(rows);
		
		JSONObject json = entrepotService.getOutEntrepotList(param);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 新增库存预警设置
	 * @param setting
	 * @param response
	 */
	@RequestMapping("addWarningSetting")
	public void addWarningSetting(WarningSetting setting, HttpServletResponse response){
		boolean flag = entrepotService.addWarningSetting(setting);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 获取库存预警设置列表
	 * @param page
	 * @param rows
	 * @param goodsName
	 * @param goodsModel
	 * @param goodsBrand
	 * @param response
	 */
	@RequestMapping("getWarningSettingList")
	public void getWarningSettingList(Integer page, Integer rows, String goodsName, String goodsModel,
			String goodsBrand, HttpServletResponse response){
		if(page == null){
			page = 1;
		}
		if(rows == null){
			rows = 10;
		}
		int begin = (page-1)*rows;
		
		JSONObject json = entrepotService.getWarningSettingList(begin, rows, goodsName, goodsModel, goodsBrand);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 删除预警设置信息
	 * @param id
	 * @param response
	 */
	@RequestMapping("deleteWarningSetting")
	public void deleteWarningSetting(String id, HttpServletResponse response){
		boolean flag = entrepotService.deleteWarningSetting(id);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 获取预警列表
	 * @param page
	 * @param rows
	 * @param goodsName
	 * @param goodsModel
	 * @param goodsBrand
	 * @param response
	 */
	@RequestMapping("getWarningList")
	public void getWarningList(Integer page, Integer rows, String goodsName, String goodsModel, String goodsBrand, 
			HttpServletResponse response){
		if(page == null){
			page = 1;
		}
		if(rows == null){
			rows = 10;
		}
		int begin = (page-1)*rows;
		
		JSONObject json = entrepotService.getWarningList(begin, rows, goodsName, goodsModel, goodsBrand);
		AjaxUtil.outputJson(response, json);
	}
}
















