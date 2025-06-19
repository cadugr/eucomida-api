package com.eucomida.api.assembler;

import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Component;

@RequiredArgsConstructor
@Component
public class Converter<T, S> {

    private final ModelMapper modelMapper;

    public S toModel(T representation, Class<S> model) {
        return modelMapper.map(representation, model);
    }

    public S toRepresentation(T model, Class<S> representation) {
        return modelMapper.map(model, representation);
    }



}
