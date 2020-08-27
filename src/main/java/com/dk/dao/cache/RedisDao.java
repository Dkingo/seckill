package com.dk.dao.cache;

import com.dk.entity.Seckill;
import com.dyuproject.protostuff.LinkedBuffer;
import com.dyuproject.protostuff.ProtostuffIOUtil;
import com.dyuproject.protostuff.runtime.RuntimeSchema;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;

@Component
public class RedisDao {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private  JedisPool jedisPool;

    private RuntimeSchema<Seckill> schema = RuntimeSchema.createFrom(Seckill.class);


    //
    // public RedisDao(String ip, int port) {
    //     jedisPool = new JedisPool(ip, port);
    // }

    /**
     * 获取redis缓存
     * 拿到的是一串二进制数组，然后进行反序列化
     * 采用自定义的序列化
     * protostuff
     */
    public Seckill getSeckill(long seckillId) {
        //redis操作逻辑
        try {
            Jedis jedis = jedisPool.getResource();
            try {
                String key = "seckillId:" + seckillId;
                //get-->byte[]--> -->反序列化-->Object(Seckill)
                //采用自定义序列化操作
                byte[] bytes = jedis.get(key.getBytes());
                //缓存重获取到
                if (bytes != null) {
                    //空对象
                    Seckill seckill = schema.newMessage();
                    ProtostuffIOUtil.mergeFrom(bytes, seckill, schema);
                    //seckill被反序列化
                    return seckill;
                }

            }finally {
                jedis.close();
            }
        }catch (Exception e) {
            logger.error(e.getMessage(), e);
        }
        return null;
    }

    public String putSeckill (Seckill seckill) {
        //set Object(Seckill) -- > 序列化  -->  byte[]
        try {
            Jedis jedis = jedisPool.getResource();

            try {
                String key = "seckillId:" + seckill.getSeckillId();
                byte[] bytes =  ProtostuffIOUtil.toByteArray(seckill, schema,
                        LinkedBuffer.allocate(LinkedBuffer.DEFAULT_BUFFER_SIZE));
                //超时缓存
                int timeout= 60 * 60;
                String result = jedis.setex(key.getBytes(), timeout, bytes);
                return result;
            } finally {
                jedis.close();
            }
        } catch (Exception e){
            logger.error(e.getMessage(), e);
        }
        return null;
    }
}
