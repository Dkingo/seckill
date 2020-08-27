package com.dk.service;

import com.dk.dto.Exposer;
import com.dk.dto.SeckillExecution;
import com.dk.entity.Seckill;
import com.dk.exception.RepeatKillException;
import com.dk.exception.SeckillColseException;
import com.dk.exception.SeckillException;
import com.github.pagehelper.PageInfo;

public interface SeckillService {

    /**
     * 查询所有秒杀记录
     * @return
     */
    PageInfo<Seckill> getSeckillList(int pageNum, int pageSize);

    /**
     * 查询单个秒杀记录
     * @param seckillId
     * @return
     */
    Seckill getById(long seckillId);

    /**
     *秒杀开启是输出秒杀接口地址
     * 否则输出系统时间和秒杀时间
     * @param seckillId
     */
    Exposer exportSeckillUrl(long seckillId);

    /**
     *执行秒杀操作
     * @param seckillId
     * @param userPhone
     * @param md5
     * @return
     */
    SeckillExecution executeSeckill(long seckillId, long userPhone, String md5)
    throws SeckillException, RepeatKillException, SeckillColseException;

    /**
     * 执行秒杀操作 存储过程
     * @param seckillId
     * @param userPhone
     * @param md5
     */
    SeckillExecution executeSeckillProcedure(long seckillId, long userPhone, String md5)
            throws SeckillException, RepeatKillException, SeckillColseException;
}
