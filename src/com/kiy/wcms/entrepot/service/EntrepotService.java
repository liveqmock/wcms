package com.kiy.wcms.entrepot.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kiy.wcms.entrepot.entity.Entrepot;
import com.kiy.wcms.entrepot.entity.EntrepotLog;
import com.kiy.wcms.entrepot.entity.EntrepotParam;
import com.kiy.wcms.entrepot.entity.EntrepotTree;
import com.kiy.wcms.entrepot.entity.Shelf;
import com.kiy.wcms.entrepot.entity.Stock;
import com.kiy.wcms.entrepot.entity.Warning;
import com.kiy.wcms.entrepot.entity.WarningSetting;
import com.kiy.wcms.entrepot.mapper.EntrepotLogMapper;
import com.kiy.wcms.entrepot.mapper.EntrepotMapper;
import com.kiy.wcms.entrepot.mapper.ShelfMapper;
import com.kiy.wcms.entrepot.mapper.StockMapper;
import com.kiy.wcms.entrepot.mapper.WarningMapper;
import com.kiy.wcms.util.PageView;

@Transactional
@Service("entrepotService")
public class EntrepotService {
	@Autowired
	private EntrepotOptionsService entrepotOptionService;
	
	@Autowired
	private EntrepotMapper entrepotMapper;
	@Autowired
	private ShelfMapper shelfMapper;
	@Autowired
	private EntrepotLogMapper entrepotLogMapper;
	@Autowired
	private StockMapper stockMapper;
	@Autowired
	private WarningMapper warningMapper;
	
	/**
	 * 获取仓库列表
	 * @param begin
	 * @param rows
	 * @return
	 */
	public JSONObject getEntrepotList(int begin, Integer rows) {
		List<Entrepot> list = entrepotMapper.getList(begin, rows);
		int total = entrepotMapper.getTotal();
		return JSONObject.fromObject(new PageView(total, list));
	}
	
	/**
	 * 新增仓库
	 * @param entrepot
	 * @return
	 */
	public boolean addEntrepot(Entrepot entrepot) {
		entrepotMapper.addEntrepot(entrepot);
		return true;
	}
	
	/**
	 * 更新仓库
	 * @param entrepot
	 * @return
	 */
	public boolean updateEntrepot(Entrepot entrepot) {
		entrepotMapper.update(entrepot);
		return true;
	}
	
	/**
	 * 获取仓库树结构
	 * @return
	 */
	public JSONArray getEntrepotTree() {
		List<EntrepotTree> list = entrepotMapper.getEntrepotTree();
		return JSONArray.fromObject(list);
	}
	
	/**
	 * 根据仓库获取货架ID
	 * @param begin
	 * @param rows
	 * @param eid
	 * @return
	 */
	public JSONObject getShelfsByEid(int begin, Integer rows, String eid) {
		List<Shelf> list = shelfMapper.getShelfsByEid(begin, rows, eid);
		int total = shelfMapper.getTotalByEid(eid);
		return JSONObject.fromObject(new PageView(total, list));
	}
	
	/**
	 * 新增货架
	 * @param shelf
	 * @return
	 */
	public boolean addShelf(Shelf shelf) {
		shelfMapper.save(shelf);
		return true;
	}
	
	/**
	 * 更新货架
	 * @param shelf
	 * @return
	 */
	public boolean updateShelf(Shelf shelf) {
		shelfMapper.update(shelf);
		return true;
	}
	
	/**
	 * 删除货架
	 * @param id
	 * @return
	 */
	public boolean deleteShelf(String id) {
		shelfMapper.delete(id);
		return true;
	}
	
	/**
	 * 根据仓库获取所有货架
	 * @param eid
	 * @return
	 */
	public JSONArray getAllShelfsByEid(String eid) {
		List<Shelf> list = shelfMapper.getAllShelfsByEid(eid);
		return JSONArray.fromObject(list);
	}
	
	/**
	 * 获取下一个入库单号
	 * @return
	 */
	public String getNextInEntrepotCode() {
		Integer nextNo = entrepotLogMapper.getNextInEntrepotCode();
		if(nextNo == null){
			nextNo = 1;
		}else{
			nextNo++;
		}
		
		String noStr = nextNo.toString();
		
		String no = "I-" + new SimpleDateFormat("yyyy-MM-dd").format(new Date()) + "-";
		
		for(int i=noStr.length();i<4;i++){
			no += "0";
		}
		
		no += noStr;
		return no;
	}
	
	/**
	 * 入库
	 * @param log
	 * @return
	 */
	public boolean inEntrepot(EntrepotLog log) {
		log.setType(0);
		entrepotLogMapper.inEntrepot(log);
		entrepotOptionService.entrepotOption(log.getGoodsId(), 
				log.getEntrepotId(), log.getShelfId(), log.getAmount(), 0);
		return true;
	}
	
	/**
	 * 获取入库记录列表
	 * @param param
	 * @return
	 */
	public JSONObject getInEntrepotList(EntrepotParam param) {
		if(param.getCreateDateStrBegin()!=null && param.getCreateDateStrBegin().trim().equals("")){
			param.setCreateDateStrBegin(null);
		}
		if(param.getCreateDateStrEnd()!=null && param.getCreateDateStrEnd().trim().equals("")){
			param.setCreateDateStrEnd(null);
		}
		List<EntrepotLog> list = entrepotLogMapper.getInEntrepotList(param);
		int total = entrepotLogMapper.getInEntrepotTotal(param);
		return JSONObject.fromObject(new PageView(total, list));
	}
	
	/**
	 * 获取库存情况
	 * @param begin
	 * @param rows
	 * @param tid
	 * @param name
	 * @param code
	 * @param model
	 * @param brand
	 * @return
	 */
	public JSONObject getGoodsStockByTid(int begin, Integer rows, String tid,
			String name, String code, String model, String brand) {
		List<Stock> list = stockMapper.getGoodsStockByTid(begin, rows, tid, name, code, model, brand);
		int total = stockMapper.getGoodsStockTotal(tid, name, code, model, brand);
		return JSONObject.fromObject(new PageView(total, list));
	}
	
	/**
	 * 出库
	 * @param log
	 * @return
	 */
	public boolean outEntrepot(EntrepotLog log) {
		boolean flag = entrepotOptionService.entrepotOption(log.getGoodsId(), log.getEntrepotId(), 
				log.getShelfId(), log.getAmount(), 1);
		if(flag){
			entrepotLogMapper.outEntrepot(log);
		}
		return flag;
	}
	
	/**
	 * 获取下一个出库单编号
	 * @return
	 */
	public String getNextOutEntrepotCode() {
		Integer nextNo = entrepotLogMapper.getNextOutEntrepotCode();
		if(nextNo == null){
			nextNo = 1;
		}else{
			nextNo++;
		}
		
		String noStr = nextNo.toString();
		
		String no = "O-" + new SimpleDateFormat("yyyy-MM-dd").format(new Date()) + "-";
		
		for(int i=noStr.length();i<4;i++){
			no += "0";
		}
		
		no += noStr;
		return no;
	}
	
	/**
	 * 获取出库记录列表
	 * @param param
	 * @return
	 */
	public JSONObject getOutEntrepotList(EntrepotParam param) {
		if(param.getCreateDateStrBegin()!=null && param.getCreateDateStrBegin().trim().equals("")){
			param.setCreateDateStrBegin(null);
		}
		if(param.getCreateDateStrEnd()!=null && param.getCreateDateStrEnd().trim().equals("")){
			param.setCreateDateStrEnd(null);
		}
		List<EntrepotLog> list = entrepotLogMapper.getOutEntrepotList(param);
		int total = entrepotLogMapper.getOutEntrepotTotal(param);
		return JSONObject.fromObject(new PageView(total, list));
	}
	
	/**
	 * 新增库存预警设置
	 * @param setting
	 * @return
	 */
	public boolean addWarningSetting(WarningSetting setting) {
		warningMapper.save(setting);
		return true;
	}
	
	/**
	 * 获取预警设置列表
	 * @param begin
	 * @param rows
	 * @param goodsName
	 * @param goodsModel
	 * @param goodsBrand
	 * @return
	 */
	public JSONObject getWarningSettingList(int begin, Integer rows,
			String goodsName, String goodsModel, String goodsBrand) {
		List<WarningSetting> list = warningMapper.getWarningSettingList(begin, rows, 
				goodsName, goodsModel, goodsBrand);
		int total = warningMapper.getWarningSettingTotal(goodsName, goodsModel, goodsBrand);
		return JSONObject.fromObject(new PageView(total, list));
	}
	
	/**
	 * 获取预警列表
	 * @param begin
	 * @param rows
	 * @param goodsName
	 * @param goodsModel
	 * @param goodsBrand
	 * @return
	 */
	public JSONObject getWarningList(int begin, Integer rows, String goodsName,
			String goodsModel, String goodsBrand) {
		List<Warning> list = warningMapper.getWarningList(begin, rows, goodsName, goodsModel, goodsBrand);
		int total = warningMapper.getWarningTotal(goodsName, goodsModel, goodsBrand);
		return JSONObject.fromObject(new PageView(total, list));
	}
	
	/**
	 * 删除预警设置信息
	 * @param id
	 * @return
	 */
	public boolean deleteWarningSetting(String id) {
		warningMapper.delete(id);
		return true;
	}
	
	
	
	
	
	
	
	
	
}
