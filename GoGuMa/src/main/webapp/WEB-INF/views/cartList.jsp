<%@ page session="false" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-0evHe/X+R7YkIZDRvuzKMRqM+OrBnVFBL6DOitfPri4tjfHxaWutUpFmBp4vmVor"
	crossorigin="anonymous">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-pprn3073KE6tl6bjs2QrFaJGz5/SUsLqktiwsUTF55Jfv3qYSDhgCecCxMW52nD2"
	crossorigin="anonymous"></script>

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css" />

<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.1/font/bootstrap-icons.css">

<link rel="stylesheet"
	href="${contextPath}/resources/css/cart/cartPage.css">

<link rel="stylesheet"
	href="${contextPath}/webjars/jquery-ui/1.13.0/jquery-ui.css">
<script type="text/javascript"
	src="${contextPath}/webjars/jquery/3.6.0/dist/jquery.js"></script>
<script type="text/javascript"
	src="${contextPath}/webjars/jquery-ui/1.13.0/jquery-ui.js"></script>
	
<script type="text/javascript">
	$(document).ready(function() {
		$('.cart-count button[count_range]').click(function(e) {
			e.preventDefault();
			var type = $(this).attr('count_range');
			var $count = $(this).parent().children('input.ccount');
			var count_val = $count.val(); // min 1
			if (type == 'm') {
				if (count_val < 1) {
					return;
				}
				$count.val(parseInt(count_val) - 1);
			} else if (type == 'p') {
				$count.val(parseInt(count_val) + 1);
			}
		});
		bindCartList();

		// 수량 증가 버튼을 클릭한 경우 실행되는 함수
		$("button[name='countUp']").click(function(){
			var token = $("meta[name='_csrf']").attr("content");
			var header = $("meta[name='_csrf_header']").attr("content");
			
			var itemObj = $(this).parents("tr");
			var cartId = Number(itemObj.find("input:checkbox[name=itemSelect]").val());
			console.log("카트아이디:", cartId);
			var data1 = JSON.stringify({'cid' : cartId});
			console.log(data1);
			$.ajax({
				type: "POST",
				url: "${contextPath}/cart/addCartCount?cartId=" + cartId,
				data: data1,
				contentType: "application/json; charset=utf-8",
				beforeSend: function(xhr){
					xhr.setRequestHeader(header, token);
				},
				success: function (response) {
					console.log("카트수량증가");
				},
				error: function(xhr, status, error){
					var errorResponse = JSON.parse(xhr.responseText);
				}/* ,
				complete: function(xht, status){
					$(this).removeAttr("disabled");
				} */
			});
		});
	});
	
	// 상품 선택
	function bindCartList(){
		if($("input:checkbox[name=allItemSelect]")){
			$("input:checkbox[name=allItemSelect]").click(function(e){
				var isChecked = $(this).is(":checked");
				$("input:checkbox[name=itemSelect]").prop("checked", isChecked);
				//가격 재계산
				
				//선택가능한것 체크
				
			});
		}
	
	// 판매가 * 수량을 계산해서 화면에 표시
	function calculateItemSellPrice(itemObj, obj){
		var selPrice = Number($("input[name=sellPr]")).val();
		var ordQty = Number($());
	}
	
	
}

</script>
<div class="container">
	<!-- 바디 전체-->
	<div class="cbody">
		<div class="contents">
			<div class="csection">
				<div class="cart-area">
					<div class="cart-head">
						<div class="cart-top">
							<div class="cart-all">
								<strong>장바구니</strong> <span>(<em class="cart-count">0</em>)
								</span>
							</div>
							<ol class="cart-list-num">
								<li class="active"><strong>01</strong> <span>장바구니</span></li>
								<li><strong>02</strong> <span>주문서작성</span></li>
								<li><strong>03</strong> <span>주문완료</span></li>
							</ol>
						</div>
						<div class="cart-bottom">
							<span>홍길동 고객님의 혜택 정보 회원등급: 실버 적립금: 100000</span>
							<div class="btngroup">
								<button type="button" class="btn btn-cart-del" onclick="">
									<i class="bi bi-cart-x"></i> <span>장바구니 비우기</span>
								</button>
							</div>
						</div>
					</div>
					<!--장바구니에 담긴 상품이 있는 경우-->
					<c:if test="${list != null or fn:length(list) != 0}">
						<div class="cart-body">
							<table class="table table-bordered border-white">
								<thead>
									<tr class="head">
										<th scope="col" class="all-select-event"><label>
												<input title="모든 상품 전체결제 설정" type="checkbox" checked="checked"
												class="all-deal-select" name="allItemSelect"> <span>&nbsp;&nbsp;전체선택</span>
										</label></th>
										<th scope="col" id="th-product-name">상품정보</th>
										<th scope="col" id="th-product-count">수량</th>
										<th scope="col" id="th-product-price">상품가격</th>
										<th scope="col" id="th-discount-price">할인금액</th>
										<th scope="col" id="th-total-price">합계</th>
										<th scope="col" id="th-order-delete">구매/삭제</th>
									</tr>
									<c:forEach var="i" items="${list }" begin="0" step="1" varStatus="status">
									<tr class="cart-product">
										<td class="product-select-event"><input type="checkbox"
											class="selectCheck" name="itemSelect" checked="checked" value="${i.cartId}"></td>
										<td class="cart-product_box">
											<div class="product-image">
												<a href="이동할 링크" class="moveProduct"> <img
													src="${i.prodImgUrl }"
													width="78" height="78" class="product-img" alt="">
												</a>
											</div>
											<div class="product-name">
												<a href="이동할 링크" class="moveProduct">${i.parentProductName }</a>
											</div>
											<div class="product-option">
												<span class="product-option-name"> 옵션: ${i.productName } </span>
											</div>
										</td>
										<td class="cart-product-count">
											<div class="cart-count">
												<button value="-" count_range="m" type="button" name="countDown">-</button> 
												<input class="ccount" value="${i.cartAmount }" readonly name="ordQty">
												<button value="+" count_range="p" type="button" name="countUp">+</button>
											</div>
										</td>
										<td class="cart-price">
											<div class="cart-product-price">
												<c:set var="proPrice" value="${i.cartPrice * i.cartAmount}"/>
												<span><fmt:formatNumber value="${proPrice}" type="currency"/></span>
											</div>
										</td>
										<td class="cart-discount">
											<div class="cart-product-discount">
												<span>${i.discountPercent }%할인</span> 
												<c:set var="disPrice" value="${proPrice  * i.discountPercent / 100 }"/>
												<span><fmt:formatNumber value="${disPrice}" type="currency"/></span>
											</div>
										</td>
										<td class="cart-total">
											<div class="cart-total-price">
												<c:set var="totPrice" value="${proPrice - disPrice}"/>
												<span><fmt:formatNumber value="${totPrice}" type="currency"/></span>
											</div>
										</td>
										<td class="cart-purchase-delete">
											<button type="button" class="btn-purchase">구매</button>
											<button type="button" class="btn-delete">삭제</button>
										</td>
									</tr>
									</c:forEach>
								</thead>
							</table>
						</div>
					</c:if>
					<!-- 장바구니에 담긴 상품이 없는 경우-->
					<c:if test="${list == null or fn:length(list) == 0}">
						<div class="nodata">
							<span class="bgcircle"> <i class="icon nodata-type"></i>
							</span>
							<p>
								<span>장바구니에 담긴 상품이 없습니다.</span>
							</p>
						</div>
					</c:if>
				</div>
				<div class="all-cart-total-price">
					<div class="all-price-area">
						총 상품가격 
						<em class="final-product-price">0원</em>
						<i class="bi bi-dash-square"></i>
						총 할인가격
						<em class="final-product-discount">0원</em>
						<i class="bi bi-arrow-right-square"></i>
						총 주문금액
						<em class="final-order-price">0원</em>
					</div>
				</div>
			</div>

		</div>
	</div>

	<!-- cfoot-->
	<div class="cfoot">
		<div class="contents">
			<div class="cart-info">
				<h3 class="major-headings">장바구니 이용안내</h3>
				<div class="cart-infocnt" role="region" aria-label="장바구니 이용안내">
					<h4 class="subheadings">장바구니 보관 안내</h4>
					<ul class="dotlist">
						<li>장바구니에 담긴 상품은 1달 동안 보관됩니다.</li>
					</ul>
					<h4 class="subheadings">무이자 할부 이용 안내</h4>
					<ul class="dotlist">
						<li>상품상세 페이지나 장바구니에 기재된 무이자할부 개월수는 해당상품을 단독 구매할 경우 적용되는
							조건입니다.</li>
						<li>여러종류의 상품을 함께 구매 할 경우, 보다 낮은 개월 수 의 무이자 할부가 적용됩니다.</li>
						<li>무이자할부 대상이 아닌 상품을 함께 구매 할 경우, 무이자 할부가 적용되지 않습니다.</li>
						<li>일부 특가상품은 무이자 할부 대상에서 제외되며 또한 각 상품별로 무이자 할부 개월수가 상이하오니, 최종
							결제 페이지에서 무이자 할부 개월수를 다시 한번 확인하시기 바랍니다.</li>
						<li>상품별로 무이자할부 혜택을 받고 싶으시다면, 개별 주문 부탁드립니다.</li>
					</ul>
				</div>
			</div>
		</div>
	</div>
</div>