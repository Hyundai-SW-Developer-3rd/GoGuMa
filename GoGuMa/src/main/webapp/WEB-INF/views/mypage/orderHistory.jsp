<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="_csrf" content="${_csrf.token}">
	<meta name="_csrf_header" content="${_csrf.headerName}">
	<title>고구마 - 고객과 구성하는 마켓</title>
    <!-- bootstrap icon -->
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.1/font/bootstrap-icons.css">
	<!-- bootstrap css -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-0evHe/X+R7YkIZDRvuzKMRqM+OrBnVFBL6DOitfPri4tjfHxaWutUpFmBp4vmVor" crossorigin="anonymous">
	<script type="text/javascript" src="${contextPath}/webjars/jquery/3.6.0/dist/jquery.js"></script>
	<style>
        a {
            text-decoration: none;
        }
        a:link {
            color: black;
        }
        a:visited {
            color: black;
        }
        .orderHistoryImg {
            width: 100%;
            height: 100%;
        }
        table {
        	table-layout: fixed;
        	word-break: break-all;
        }
    </style>
    
   <style>
		<%@ include file="/resources/css/myreview.css" %>
	</style>
</head>

<script type="text/javascript">
	$(document).ready(function() {
	  
		console.log("${receiptHistory}");
		
	});
</script>
<body>
	<%@ include file="../header.jsp" %>
	<div class="container mt-5" style="min-width: 1200px">
		<div class="row">
			<%@ include file="mypageMenu.jsp" %>
            <div class="col">
                <%@ include file="quickMenu.jsp" %>
                <div>
                    <h5><b>주문내역</b></h5>
                </div>
               
                <c:if test="${receiptHistory.size() < 1}">
					<div style="text-align: center;">
						<img class="no-review-img" src="https://image.hmall.com/p/img/co/icon/ico-nodata-type12-1x.svg" />
					   	<h5 class="no_result" style="margin-top: 0px;">조회 내역이 없습니다.</h5>
			   		</div>
		         </c:if>
				<c:forEach var="receiptDTO" items="${receiptHistory}">
					<c:if test="${receiptDTO.couponDiscount == 0 && receiptDTO.usagePoint == 0 && receiptDTO.orderList[0].status != 'V'}">
					<!-- 결제 forEach 시작 -->
					<input type="hidden" id="impUid${receiptDTO.receiptId}" value="${receiptDTO.impUid}" />
					<div class="col border border-2 rounded p-4 mb-3">
	                    <div class="d-flex flex-row">
	                        <div class="col">
	                            <h5><b><fmt:formatDate pattern="yyyy-MM-dd" value="${receiptDTO.orderDate}" /></b></h5>
	                        </div>
	                        <div class="d-flex flex-column">
	                            <a href="${contextPath}/mypage/orderHistory/${receiptDTO.receiptId}">주문 상세보기</a>
	                        </div>
	                    </div>
	                    <div class="border border-1 rounded">
	                        <table>
			                    	<c:forEach var="orderDTO" items="${receiptDTO.orderList}">
	                            		<!-- 주문 forEach 시작 -->
	                            		<input type="hidden" id="price${orderDTO.orderId}" value="${orderDTO.price}"/>
	                            		<input type="hidden" id="count${orderDTO.orderId}" value="${orderDTO.count}"/>
			                                <tr class="border-bottom">
			                                    <td class="col-1 p-3">
			                                    	<a href="${contextPath}/category/1/${orderDTO.categoryId}/detail/${orderDTO.productId}">
			                                        	<img class="orderHistoryImg" src="${orderDTO.image}" style="width:100px; height:100px;">
			                                        </a>
			                                    </td>
			                                    <td class="col-5 border-end">
			                                    	<a href="${contextPath}/category/1/${orderDTO.categoryId}/detail/${orderDTO.productId}" class="text-truncate">
			                                    		<span><b>${orderDTO.pname}</b></span>
			                                    		<br>
			                                    		<span>옵션 : ${orderDTO.cname}</span>
			                                    	</a>
			                                    </td>
			                                    <td class="border-end">
			                                        <div class="col m-auto" style="width: 100px" align="center">
			                                            <div>
			                                                <fmt:formatNumber value="${orderDTO.price}" />원
			                                            </div>
			                                            <div>
			                                                (${orderDTO.count}개)
			                                            </div>
			                                        </div>
			                                    </td>
			                                    <td>
			                                        <div class="col" align="center">
			                                        	<c:choose>
			                                        		<c:when test="${orderDTO.status eq 'N'}">
				                                        		<div>
					                                                <h5><b>주문 완료</b></h5>
					                                            </div>
					                                            <div class="mb-2">
					                                                <button type="button" class="btn btn-sm btn-outline-dark" onclick="configBtn(${orderDTO.orderId})">구매확정</button>
					                                            </div>
					                                            <div class="mt-2">
					                                                <button type="button" class="btn btn-sm btn-outline-dark" onclick="cancelBtn(${receiptDTO.receiptId}, ${orderDTO.orderId})">주문취소</button>
					                                            </div>
			                                        		</c:when>
			                                        		<c:when test="${orderDTO.status eq 'F'}">
			                                        			<div>
					                                                <h5><b>구매 완료</b></h5>
					                                            </div>
					                                            <div class="mb-2">
					                                            </div>
			                                        		</c:when>
			                                        		<c:when test="${orderDTO.status eq 'V'}">
			                                        			<div>
					                                                <h5><b>입금 예정</b></h5>
					                                            </div>
			                                        		</c:when>
			                                        		<c:otherwise>
			                                        			<div>
					                                                <h5><b>취소 완료</b></h5>
					                                            </div>
			                                        		</c:otherwise>
			                                        	</c:choose>
			                                        </div>
			                                    	</td>
			                                	</tr> 
		                                <!-- 주문 forEach 종료 -->
	                                </c:forEach>
	                        </table>
	                    </div>
	                </div>
	                </c:if>
	                <!-- 쿠폰 or 포인트 or 무통장 으로 결제 한경우 -->
	                <c:if test="${receiptDTO.couponDiscount != 0 || receiptDTO.usagePoint != 0 || receiptDTO.orderList[0].status == 'V'}">
	                	<!-- 결제 forEach 시작 -->
						<input type="hidden" id="impUid${receiptDTO.receiptId}" value="${receiptDTO.impUid}" />
						<div class="col border border-2 rounded p-4 mb-3">
							<div class="d-flex flex-row">
		                        <div class="col">
		                            <h5><b><fmt:formatDate pattern="yyyy-MM-dd" value="${receiptDTO.orderDate}" /></b></h5>
		                        </div>
		                        <div class="d-flex flex-column">
		                            <a href="${contextPath}/mypage/orderHistory/${receiptDTO.receiptId}">주문 상세보기</a>
		                        </div>
	                    	</div>
	                    	<div class="border border-1 rounded">
	                        <table>
			                    	<c:forEach var="orderDTO" items="${receiptDTO.orderList}">
	                            		<!-- 주문 forEach 시작 -->
	                            		<input type="hidden" id="price${orderDTO.orderId}" value="${orderDTO.price}"/>
	                            		<input type="hidden" id="count${orderDTO.orderId}" value="${orderDTO.count}"/>
			                                <tr class="border-bottom">
			                                    <td class="col-1 p-3">
			                                    	<a href="${contextPath}/category/1/${orderDTO.categoryId}/detail/${orderDTO.productId}">
			                                        	<img class="orderHistoryImg" src="${orderDTO.image}" style="width:100px; height:100px;">
			                                        </a>
			                                    </td>
			                                    <td class="col-5 border-end">
			                                    	<a href="${contextPath}/category/1/${orderDTO.categoryId}/detail/${orderDTO.productId}" class="text-truncate">
			                                    		<span><b>${orderDTO.pname}</b></span>
			                                    		<br>
			                                    		<span>옵션 : ${orderDTO.cname}</span>
			                                    	</a>
			                                    </td>
			                                    <td class="border-end">
			                                        <div class="col m-auto" style="width: 100px" align="center">
			                                            <div>
			                                                <fmt:formatNumber value="${orderDTO.price}" />원
			                                            </div>
			                                            <div>
			                                                (${orderDTO.count}개)
			                                            </div>
			                                        </div>
			                                    </td>
			                                </tr> 
		                                <!-- 주문 forEach 종료 -->
	                                </c:forEach>
	                        </table>
	                    </div>
	                    	<div class="col" align="center">
                               	<c:choose>
                               		<c:when test="${receiptDTO.orderList[0].status eq 'N'}">
                                		<div>
                                         <div style="margin-top:20px;"><b>주문 완료</b></div>
                                         <div style="text-align: right;">
                                         	<button type="button" class="btn btn-sm btn-outline-dark" onclick="cancelBtn(${receiptDTO.receiptId}, ${orderDTO.orderId})">주문취소</button>
                                         	<button type="button" class="btn btn-sm btn-outline-dark" onclick="configBtn(${orderDTO.orderId})">구매확정</button>
                                         </div>
                                     	</div>
                               		</c:when>
                               		<c:when test="${receiptDTO.orderList[0] eq 'F'}">
                               			<div>
                                          <div style="margin-top:20px;"><b>구매 완료</b></div>
                                     </div>
                                     <div class="mb-2">
                                     </div>
                               		</c:when>
                               		<c:when test="${receiptDTO.orderList[0] eq 'V'}">
                               			<div>
                                          <div style="margin-top:20px;"><b>입금 대기중</b></div>
                                     </div>
                               		</c:when>
                               		<c:otherwise>
                               			<div>
                                          <div style="margin-top:20px;"><b>취소 완료</b></div>
                                     </div>
                               		</c:otherwise>
                               	</c:choose>
                            </div>
						</div>
	                </c:if>
	                <!-- 결제 forEach 종료 -->
				</c:forEach>
            </div>
        </div>
    </div>
   	<%@ include file="../footer.jsp" %>
</body>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/js/bootstrap.bundle.min.js" integrity="sha384-pprn3073KE6tl6bjs2QrFaJGz5/SUsLqktiwsUTF55Jfv3qYSDhgCecCxMW52nD2" crossorigin="anonymous"></script>
<script type="text/javascript" src="<c:url value='/webjars/jquery/3.6.0/dist/jquery.js' />"></script>
<script type="text/javascript">

	function configBtn(orderId) {
		if(confirm("구매확정 하시겠습니까?")) {
			let token = $("meta[name='_csrf']").attr("content");
		    let header = $("meta[name='_csrf_header']").attr("content");
			$.ajax({
				url : "${contextPath}/mypage/orderHistory/updateOrderStatus",
				type : "POST",
				data : {
					orderId : orderId,
					status : 'F'
				},
				beforeSend : function(xhr) {
		            xhr.setRequestHeader(header, token);
	            },
				success:function(result) {
					if(result==1) {
						window.location.href = "${contextPath}/mypage/orderHistory";
					} else {
						alert('구매확정 오류');
					}
				},
				error:function(xhr, status, error) {
    				var errorResponse = JSON.parse(xhr.responseText);
    				var errorCode = errorResponse.code;
    				var message = errorResponse.message;
    				alert(message);
    			}
			});
		}
	}
	
	/**
	 * @작성자: Moon Seokho
	 * @Date: 2022. 6. 7.
	 * @프로그램설명: 환불요청을 받을 URL
	 * @변경이력: 
	 */
	function cancelPay(receiptId, orderId) {
	  	let token = $("meta[name='_csrf']").attr("content");
    	let header = $("meta[name='_csrf_header']").attr("content");
    	console.log();
		$.ajax({
			url : "${contextPath}/mypage/api/payment/cancel",
			type : "POST",
			data : {
			    uid : $("#impUid"+receiptId).val(),
			  	cancelAmount : $("#price"+orderId).val() * $("#count"+orderId).val(),
			  	reason : "",
			  	refundBank : "",
			  	refundHolder : "",
			  	refundAccount : ""
			},
			beforeSend : function(xhr) {
        		xhr.setRequestHeader(header, token);
        	},
        	success:function(result) {
        		return;
        	},
        	error:function(xhr, status, error) {
				var errorResponse = JSON.parse(xhr.responseText);
				var errorCode = errorResponse.code;
				var message = errorResponse.message;
				alert(message);
			}
        });
	}
	/**
	 * @작성자: Moon Seokho
	 * @Date: 2022. 6. 7.
	 * @프로그램설명: 환불요청을 받을 URL
	 * @변경이력: 
	 */
	function cancelAllBtn(receiptId){
	  	let token = $("meta[name='_csrf']").attr("content");
	  	let header = $("meta[name='_csrf_header']").attr("content");
	  	console.log();
		$.ajax({
			url : "${contextPath}/mypage/api/payment/cancel",
			type : "POST",
			data : {
			    uid : $("#impUid"+receiptId).val(),
			  	cancelAmount : $("#price"+orderId).val() * $("#count"+orderId).val(),
			  	reason : "",
			  	refundBank : "",
			  	refundHolder : "",
			  	refundAccount : ""
			},
			beforeSend : function(xhr) {
	      		xhr.setRequestHeader(header, token);
	      	},
	      	success:function(result) {
	      		return;
	      	},
	      	error:function(xhr, status, error) {
				var errorResponse = JSON.parse(xhr.responseText);
				var errorCode = errorResponse.code;
				var message = errorResponse.message;
				alert(message);
			}
	      });
	}
	
	
	function cancelBtn(receiptId, orderId) {
		if(confirm("주문을 취소하시겠습니까?")) {
			let token = $("meta[name='_csrf']").attr("content");
		    let header = $("meta[name='_csrf_header']").attr("content");
			$.ajax({
				url : "${contextPath}/mypage/orderHistory/updateOrderStatus",
				type : "POST",
				data : {
					orderId : orderId,
					status : 'C'
				},
				beforeSend : function(xhr) {
		            xhr.setRequestHeader(header, token);
	            },
				success:function(result) {
					if(result==1) {
				  		cancelPay(receiptId, orderId);
				  		alert("상품 주문이 취소되었습니다. 빠른 시일 이내에 환불 처리 됩니다.");
						window.location.href = "${contextPath}/mypage/orderHistory";
					} else {
						alert('주문취소 중에 오류가 발생했습니다.');
					}
				},
				error:function(xhr, status, error) {
    				var errorResponse = JSON.parse(xhr.responseText);
    				var errorCode = errorResponse.code;
    				var message = errorResponse.message;
    				alert(message);
    			}
			});
		}
	}
</script>
</html>