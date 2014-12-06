package com.kiy.wcms.procurementplan.entity;
/**
 * 采购订单附件
 * @author wuwenlong
 * @date 2014年10月04日
 */
public class ContractAtta {
	/**
	 * 主键
	 */
	private int id;
	/**
	 * 采购订单主键
	 */
	private int contractId;
	/**
	 * 附件路径
	 */
	private String filePath;
	/**
	 * 附件名称
	 */
	private String fileName;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getContractId() {
		return contractId;
	}
	public void setContractId(int contractId) {
		this.contractId = contractId;
	}
	public String getFilePath() {
		return filePath;
	}
	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
}
