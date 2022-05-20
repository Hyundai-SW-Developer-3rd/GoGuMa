package com.ggm.goguma.service.cart;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ggm.goguma.dto.cart.CartDTO;
import com.ggm.goguma.dto.cart.CartItemDTO;
import com.ggm.goguma.mapper.CartMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class CartServiceImpl implements CartService{
	
	@Setter(onMethod_ = @Autowired) 
	private CartMapper cartMapper;
	
	@Override
	public List<CartItemDTO> getCartList(int memberId) throws Exception {
		return cartMapper.getCartList(memberId);
	}

	@Override
	public void addCartCount(long cartId) throws Exception {
		cartMapper.addCartCount(cartId);
		
	}

}
