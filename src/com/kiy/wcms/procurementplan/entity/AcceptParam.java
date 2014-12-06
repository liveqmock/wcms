package com.kiy.wcms.procurementplan.entity;

public class AcceptParam {
	private int begin,rows,status;
	
	private String goodsName,goodsModel,goodsBrand,applyNo,supply,arriveDateBeginStr,arriveDateEndStr;
	
	private Long arriveDateBegin,arriveDateEnd;

	public int getBegin() {
		return begin;
	}

	public void setBegin(int begin) {
		this.begin = begin;
	}

	public int getRows() {
		return rows;
	}

	public void setRows(int rows) {
		this.rows = rows;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	public String getGoodsName() {
		return goodsName;
	}

	public void setGoodsName(String goodsName) {
		this.goodsName = goodsName;
	}

	public String getGoodsModel() {
		return goodsModel;
	}

	public void setGoodsModel(String goodsModel) {
		this.goodsModel = goodsModel;
	}

	public String getGoodsBrand() {
		return goodsBrand;
	}

	public void setGoodsBrand(String goodsBrand) {
		this.goodsBrand = goodsBrand;
	}

	public String getApplyNo() {
		return applyNo;
	}

	public void setApplyNo(String applyNo) {
		this.applyNo = applyNo;
	}

	public String getSupply() {
		return supply;
	}

	public void setSupply(String supply) {
		this.supply = supply;
	}

	public String getArriveDateBeginStr() {
		return arriveDateBeginStr;
	}

	public void setArriveDateBeginStr(String arriveDateBeginStr) {
		this.arriveDateBeginStr = arriveDateBeginStr;
	}

	public String getArriveDateEndStr() {
		return arriveDateEndStr;
	}

	public void setArriveDateEndStr(String arriveDateEndStr) {
		this.arriveDateEndStr = arriveDateEndStr;
	}

	public Long getArriveDateBegin() {
		return arriveDateBegin;
	}

	public void setArriveDateBegin(Long arriveDateBegin) {
		this.arriveDateBegin = arriveDateBegin;
	}

	public Long getArriveDateEnd() {
		return arriveDateEnd;
	}

	public void setArriveDateEnd(Long arriveDateEnd) {
		this.arriveDateEnd = arriveDateEnd;
	}
}
