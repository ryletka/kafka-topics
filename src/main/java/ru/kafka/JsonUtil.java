package ru.kafka;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.AccessLevel;
import lombok.NoArgsConstructor;

@NoArgsConstructor(access = AccessLevel.PRIVATE)
public final class JsonUtil {

    private static final ObjectMapper OBJECT_MAPPER;

    static {
        ObjectMapper mapper = new ObjectMapper();
        mapper.disable(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES);
        OBJECT_MAPPER = mapper;
    }

    public static String serialize(Object msg) throws Exception {
        try {
            return OBJECT_MAPPER.writeValueAsString(msg);
        } catch (JsonProcessingException e) {
            throw new Exception(e);
        }
    }
}
