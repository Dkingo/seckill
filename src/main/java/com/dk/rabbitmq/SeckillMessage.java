package com.dk.rabbitmq;


import com.dk.entity.SeckillUser;

public class SeckillMessage {

    private SeckillUser seckillUser;
    private long goodsId;

    public SeckillUser getSeckillUser() {
        return seckillUser;
    }

    public void setSeckillUser(SeckillUser seckillUser) {
        this.seckillUser = seckillUser;
    }

    public long getGoodsId() {
        return goodsId;
    }

    public void setGoodsId(long goodsId) {
        this.goodsId = goodsId;
    }

    @Override
    public String toString() {
        return "SeckillMessage{" +
                "seckillUser=" + seckillUser +
                ", goodsId=" + goodsId +
                '}';
    }
}
