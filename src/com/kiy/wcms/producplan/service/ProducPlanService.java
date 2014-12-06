package com.kiy.wcms.producplan.service;

import java.util.List;

import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kiy.wcms.Global;
import com.kiy.wcms.design.mapper.DesignMapper;
import com.kiy.wcms.order.entity.Order;
import com.kiy.wcms.order.entity.OrderDetail;
import com.kiy.wcms.producplan.entity.ProducPlan;
import com.kiy.wcms.producplan.entity.ProducPlanParam;
import com.kiy.wcms.producplan.mapper.ProducPlanMapper;
import com.kiy.wcms.sys.entity.Audit;
import com.kiy.wcms.sys.entity.SysUser;
import com.kiy.wcms.sys.service.AuditService;
import com.kiy.wcms.util.PageView;

@Transactional
@Service("producPlanService")
public class ProducPlanService {
	@Autowired
	private ProducPlanMapper producPlanMapper;
	@Autowired
	private AuditService auditService;
	@Autowired
	private DesignMapper designMapper;
	
	/**
	 * 获取生成计划列表
	 * @param producPlanParam
	 * @return
	 */
	public JSONObject getProducPlanList(ProducPlanParam producPlanParam) {
		List<ProducPlan> list = producPlanMapper.getProducPlanList(producPlanParam);
		int total = producPlanMapper.getTotal(producPlanParam);
		PageView page = new PageView(total, list);
		return JSONObject.fromObject(page);
	}
	
	/**
	 * 保存技术参数
	 * @param orderDetail
	 * @return
	 */
	public boolean saveTechParam(OrderDetail orderDetail) {
		producPlanMapper.saveTechParam(orderDetail);
		return true;
	}
	
	/**
	 * 提交生成计划
	 * @param id
	 * @return
	 */
	public boolean submitProducPlan(String id) {
		producPlanMapper.submitProducPlan(id);
		return true;
	}
	
	/**
	 * 获取审批列表
	 * @param seeStatus
	 * @return
	 */
	public JSONObject getAuditList(ProducPlanParam param) {
		List<ProducPlan> list =  producPlanMapper.getAuditList(param);
		int total = producPlanMapper.getAuditTotal(param);
		PageView page = new PageView(total, list);
		return JSONObject.fromObject(page);
	}
	
	/**
	 * 提交审批
	 * @param id
	 * @param option
	 * @param status
	 * @param comment
	 * @param user
	 * @return
	 */
	public boolean submitAudit(String id, String option, int status,
			String comment, SysUser user) {
		producPlanMapper.submitAudit(id, status);
		Audit audit = new Audit();
		audit.setIoption(Integer.parseInt(option));
		audit.setComment(comment);
		audit.setKey(Integer.parseInt(id));
		audit.setType(Global.AUDIT_TYPE_PRODUCTPLAN);
		audit.setUserId(user.getId());
		auditService.saveAudit(audit);
		
		if(status == 30){//保存设计方案
			//获取所有订单明细ID
			List<Integer> detaiIdList = producPlanMapper.getDetailIdList(id);
			//批量保存设计方案
			designMapper.batchSave(detaiIdList, id);
		}
		return true;
	}
	
	/**
	 * 获取被退回的生产计划总数
	 * @return
	 */
	public int getBackTotal() {
		
		return producPlanMapper.getBackTotal();
	}
	
	/**
	 * 获取未提交总数
	 * @return
	 */
	public int getUnPayTotal() {
		return producPlanMapper.getUnPayTotal();
	}
	
	/**
	 * 获取未审批总数
	 * @param seeStatus
	 * @return
	 */
	public int getUnAuditTotal(String seeStatus) {
		ProducPlanParam param = new ProducPlanParam();
		param.setAuditStatus(0);
		param.setSeeStatus(seeStatus);
		return producPlanMapper.getAuditTotal(param);
	}
	
	/**
	 * 获取订单基本信息
	 * @param id
	 * @return
	 */
	public Order getOrderByProId(String id) {
		return producPlanMapper.getOrderByProId(id);
	}

	/**
	 * 获取所有订单明细
	 * @param id
	 * @return
	 */
	public List<OrderDetail> getOrderDetailListByProId(String id) {
		return producPlanMapper.getOrderDetailListByProId(id);
	}
}
