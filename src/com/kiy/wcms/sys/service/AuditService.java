package com.kiy.wcms.sys.service;

import java.util.List;

import net.sf.json.JSONArray;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kiy.wcms.sys.entity.Audit;
import com.kiy.wcms.sys.mapper.AuditMapper;

@Transactional
@Service("auditService")
public class AuditService {
	@Autowired
	private AuditMapper auditMapper;
	
	/**
	 * 获取审批记录列表
	 * @param id
	 * @param type
	 * @return
	 */
	public JSONArray getAuditList(String id, String type) {
		List<Audit> list = auditMapper.getAuditList(id, type);
		return JSONArray.fromObject(list);
	}
	
	/**
	 * 保存审批记录
	 * @param audit
	 */
	public void saveAudit(Audit audit){
		auditMapper.save(audit);
	}
}
