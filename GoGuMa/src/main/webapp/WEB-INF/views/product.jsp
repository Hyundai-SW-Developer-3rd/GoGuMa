<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<html>
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="http://code.jquery.com/jquery-1.11.3.min.js"></script>
<head>
    <title>Product</title>
    
    <!-- bootstrap css -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-0evHe/X+R7YkIZDRvuzKMRqM+OrBnVFBL6DOitfPri4tjfHxaWutUpFmBp4vmVor" crossorigin="anonymous">

    <!-- bootstrap js -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-pprn3073KE6tl6bjs2QrFaJGz5/SUsLqktiwsUTF55Jfv3qYSDhgCecCxMW52nD2"
        crossorigin="anonymous"></script>
    
    <style>
    	<%@ include file="/resources/css/product.css" %>
    </style>
    
    <script>
 		// 가격 format() 함수
 		Number.prototype.format = function() {
	 		if(this==0) return 0;     
 			var reg = /(^[+-]?\d+)(\d{3})/;    
 			var n = (this + '');
 			
 			while (reg.test(n))
 				n = n.replace(reg, '$1' + ',' + '$2');     
 				
			return n;
		};
    
	    function selectOption(option) { // 옵션을 변경한 경우 구매 수량 초기화
	    	document.getElementById("numBox").value = 1;

	    	var optionName = $("#option option:selected").text(); // 옵션 상품 이름
	    	var optionID = $("#option option:selected").data("id"); // 옵션 상품 번호
	    	var optionPrice = $("#option option:selected").data("price"); // 옵션 상품 가격
	    	
	    	$('.selectedOption').text(optionName);
	    	$('.total_price').text(optionPrice.format() + "원"); // 초기화
	    }
	    
        $(document).ready(function () {
        	$('.option-img').click(function() {
        		var src = $(this).data("src");
        		
        		// 선택한 옵션 이미지로 썸네일 이미지 변경
        		$('.thumbnailImg').attr("src", src);
         	});
        	
            $("#plus").click(function () { // 수량 증가
                var num = $("#numBox").val();
                var plusNum = Number(num) + 1;
                
    	    	var optionName = $("#option option:selected").text(); // 옵션 상품 이름
                var stock = $("#option option:selected").val(); // 선택한 옵션의 최대 수량까지 증가 가능
                var optionPrice = $("#option option:selected").data("price"); // 옵션 상품 가격
                
                if (optionName != "선택 없음") {
	                if(plusNum > stock) { // 남은 재고를 넘은 경우
	                	$("#numBox").val(num);
	                	$('.total_price').text((optionPrice * num).format() + "원");
	                	alert("더이상 구매하실 수 업습니다.");
	                } else {
	                	$("#numBox").val(plusNum);        
	                	$('.total_price').text((optionPrice * plusNum).format() + "원");
	                }
                } else {
                	alert("옵션을 선택하세요.");
                }
            });

            $("#minus").click(function () { // 수량 감소
                var num = $("#numBox").val();
                var minusNum = Number(num) - 1;

    	    	var optionName = $("#option option:selected").text(); // 옵션 상품 이름
            	var optionPrice = $("#option option:selected").data("price"); // 옵션 상품 가격
				
            	if (optionName != "선택 없음") {
            		if (minusNum <= 0) {
                        $("#numBox").val(num);
                        $('.total_price').text((optionPrice * num).format() + "원");
                    } else {
                        $("#numBox").val(minusNum);
                        $('.total_price').text((optionPrice * minusNum).format() + "원");
                    }
            	} else {
                	alert("옵션을 선택하세요.");
                }
            });

            $(function () {
                $('.tabcontent > div').hide();
                $('.tabnav a').click(function () {
                    $('.tabcontent > div').hide().filter(this.hash).fadeIn();
                    $('.tabnav a').removeClass('active');
                    $(this).addClass('active');
                    return false;
                }).filter(':eq(0)').click();
            });

            $(function () {
                // 이미지 클릭시 해당 이미지 모달
                $(".imgC").click(function () {
                    $(".modal").show();
                    // 해당 이미지 가겨오기
                    var imgSrc = $(this).children("img").attr("src");
                    var imgAlt = $(this).children("img").attr("alt");
                    $(".modalBox img").attr("src", imgSrc);
                    $(".modalBox img").attr("alt", imgAlt);
                });

                $(".write-modal").hide();

                // .modal안에 button을 클릭하면 .modal닫기
                $(".modal button").click(function () {
                    $(".modal").hide();
                });

                // .modal밖에 클릭시 닫기
                $(".modal").click(function (e) {
                    if (e.target.className != "modal") {
                        return false;
                    } else {
                        $(".modal").hide();
                    }
                });

                // 상품평 쓰기 버튼
                $(".writeBtn").click(function () {
                    $(".write-modal").show();
                });

                // 취소하기 버튼 클릭시 닫기
                $("#cancelBtn").click(function () {
                    $(".write-modal").hide();
                });
            });
            
            $('#cartBtn').on("click", function() { // 장바구니 담기
            	var optionName = $("#option option:selected").text(); // 옵션 상품 이름
            	
            	if (optionName != "선택 없음") {
	            	var token = $("meta[name='_csrf']").attr("content");
	        		var header = $("meta[name='_csrf_header']").attr("content");
	
	                var optionID = $("#option option:selected").data("id");
	                var cartAmount = $("#numBox").val();
	                
	        		var data = {
	        			"productId" : optionID,
	        			"cartAmount" : cartAmount
	        		};
	        		$.ajax({
	        			type : "POST",
	        			url : "${contextPath}/cart/api/insertCart",
	        			data : data,
	        			beforeSend : function(xhr) {
	        				xhr.setRequestHeader(header, token);
	        			},
	        			success : function(result) {
	        				if(result){
	        					alert("장바구니에 상품이 담겼습니다.");
	        				} else {
	        					alert("이미 장바구니에 담겨있는 상품입니다.")
	        				}
	        			},
	        			error : function(xhr, status, error) {
	        				var errorResponse = JSON.parse(xhr.responseText);
	        				var errorCode = errorResponse.code;
	        				var message = errorResponse.message;
	
	        				alert(message);
	        			}
	        		});
            	} else {
                	alert("옵션을 선택하세요.");
                }
        	});
            
            $('#buyBtn').on("click", function() { // 바로구매하기
				var optionName = $("#option option:selected").text(); // 옵션 상품 이름
            	
            	if (optionName != "선택 없음") {
	            	var token = $("meta[name='_csrf']").attr("content");
	        		var header = $("meta[name='_csrf_header']").attr("content");
	                
	        		var data = {
	        			// *** 바로구매하기 위해 보낼 데이터 ***
	        		};
	        		$.ajax({
	        			type : "POST",
	        			url : "${contextPath}/order",
	        			data : data,
	        			beforeSend : function(xhr) {
	        				xhr.setRequestHeader(header, token);
	        			},
	        			success : function(result) {
	        				// *** 결과 처리 ***
	        			},
	        			error : function(xhr, status, error) {
	        				var errorResponse = JSON.parse(xhr.responseText);
	        				var errorCode = errorResponse.code;
	        				var message = errorResponse.message;
	
	        				alert(message);
	        			}
	        		});
            	} else {
                	alert("옵션을 선택하세요.");
                }
            });
            
            $('#finishBtn').on("click", function() { // 상품평 작성하기
            	var token = $("meta[name='_csrf']").attr("content");
        		var header = $("meta[name='_csrf_header']").attr("content");
        		
            	var productID = $("#productID").val(); // 구매한 상품 번호
                var memberID = $("#memberID").val(); // 로그인한 회원 번호
               	var content = $(".write-review-content").val(); // 상품평 내용
               	var list = new Array();
               	
               	$(".uploadResult ul li").each(function(i, obj) {
        			var jobj = $(obj);
        			
        			var attachDTO = new Object();
        			attachDTO.imageName = jobj.data("imagename");
        			attachDTO.imagePath = jobj.data("imagepath");
        			list.push(attachDTO);
        		});
               	
        		var data = {
        			productID : productID,
        			memberID : memberID,
        			content : content,
        			attachList : list
        		};
        		
        		$.ajax({
		            url: "${contextPath}/category/1/insertReview",
		            type: "POST",
		            contentType: 'application/json; charset=utf-8',
		            data: JSON.stringify(data),
		            beforeSend : function(xhr) {
        				xhr.setRequestHeader(header, token);
        			},
		            success : function(result){
		            	if (result == 1) {
			                $(".modal").hide();
			                alert("상품평이 등록되었습니다.");
			                location.reload();
		            	} else {
		            		alert("상품평 등록 실패");
		            	}
		            },error : function(xhr, status, error) {
        				var errorResponse = JSON.parse(xhr.responseText);
        				var errorCode = errorResponse.code;
        				var message = errorResponse.message;
        				alert(message);
        			}
		        });
        	});
            
            $('#deleteBtn').on("click", function() { // 상품평 삭제
            	var token = $("meta[name='_csrf']").attr("content");
        		var header = $("meta[name='_csrf_header']").attr("content");
        		
            	var reviewID = $("#reviewID").val(); // 삭제할 상품 번호
                
        		var data = {
        			"reviewID" : reviewID
        		};
        		
        		$.ajax({
    	            url: "${contextPath}/category/1/deleteReview",
    	            type: "POST",
    	            data: data,
    	            beforeSend : function(xhr) {
        				xhr.setRequestHeader(header, token);
        			},
    	            success : function(result){
    	            	if (result) {
    	            		alert("상품평이 삭제되었습니다.");
    		                location.reload();
    	            	}
    	            },error : function(xhr, status, error) {
        				var errorResponse = JSON.parse(xhr.responseText);
        				var errorCode = errorResponse.code;
        				var message = errorResponse.message;
        				alert(message);
        			}
    	        });
        	});
        	
        	$(".uploadResult").on("click", "button", function(e) {
            	var token = $("meta[name='_csrf']").attr("content");
        		var header = $("meta[name='_csrf_header']").attr("content");
        		
        		console.log("delete file");
        		var targetFile = $(this).data("imagename");
        		var targetLi = $(this).closest("li");
        		
        		var data = {
        			imageName : targetFile
        		};
        		
        		$.ajax({
        			url: '${contextPath}/category/1/deleteFile',
        			data: data,
        			type: 'POST',
        			beforeSend : function(xhr) {
        				xhr.setRequestHeader(header, token);
        			},
       				success: function(result) {
       					alert("이미지가 삭제되었습니다.");
       					
       					targetLi.remove();
       				},error : function(xhr, status, error) {
        				var errorResponse = JSON.parse(xhr.responseText);
        				var errorCode = errorResponse.code;
        				var message = errorResponse.message;
        				alert(message);
        			}
        		});
        	});
        	
        	var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
        	var maxSize = 5242880;
        	
        	function checkExtension(fileName, fileSize){
        		if(fileSize >= maxSize){
        			alert("파일 사이즈 초과");
        			return false;
        		}
        		if(regex.test(fileName)){
        			alert("해당 종류의 파일은 업로드 할 수 없습니다.");
        			return false;
        		}
        		return true;
        	}
        	
        	function showUploadResult(uploadResultArr) {
        		if(!uploadResultArr || uploadResultArr.length == 0) {return;}
        		
        		var uploadUL = $(".uploadResult ul");
        		
        		var str="";
        		
        		$(uploadResultArr).each(function(i, obj){
        			str += "<li data-imagepath='"+obj.imagePath+"'";
    				str += " data-imagename='"+obj.imageName+"' ><div>";
    				str += "<span>"+obj.imageName+"</span>";
    				str += "<button type='button' data-imagename='"+obj.imageName+"'>X</button><br>";
    				str += "<img src='" + obj.imagePath + "'>";
    				str += "</div>";
    				str += "</li>";
        		}); 
        		
        		uploadUL.append(str);
        	}
        	
        	$("input[type='file']").change(function(e){
        		var token = $("meta[name='_csrf']").attr("content");
        		var header = $("meta[name='_csrf_header']").attr("content");
        		
        		var formData = new FormData();
        		var inputFile = $("input[name='uploadFile']");
        		var files = inputFile[0].files;
        		console.log(files);
        		
        		for(var i = 0; i < files.length ; i++){
        			if(!checkExtension(files[i].imageName, files[i].size)){
        				return false;
        			}
        			formData.append("uploadFile", files[i]);
        		}
        	
        		$.ajax({
        			url: '${contextPath}/category/1/uploadAjaxAction',
        			processData: false,
        			contentType: false,
        			data: formData,
        			beforeSend : function(xhr) {
        				xhr.setRequestHeader(header, token);
        			},
        			type: 'POST',
        			dataType: 'json',
       				success: function(result){
       					console.log(result);
        				
       					attachList = result;
       					
        				showUploadResult(result);
        			}, error : function(xhr, status, error) {
        				var errorResponse = JSON.parse(xhr.responseText);
        				var errorCode = errorResponse.code;
        				var message = errorResponse.message;
        				alert(message);
        			}
        		});
        	});
        });
    </script>
</head>
<body>
	<%@ include file="header.jsp" %>
	<div class="prodlist">
        <h1 style="text-align: center">${categoryName}</h1>
		
        <hr>

        <div class="prodInfo">
        	<div class="wrap">
           		<img class="thumbnailImg" id="thumbnailImg" src="${productInfo.prodimgurl}" style="float: left;" />
        	</div>

            <div class="product_detail">
                <table>
                	<tr>
	                    <td colspan='2'>
	                        <h1>${productInfo.productName}</h1>
	                    </td>
                    </tr>
                    <tr>
                    	<td width="30%">가격</td>
                    	<td width="70%">
                            <h2><fmt:formatNumber value="${productInfo.productPrice}" pattern="#,###" />원</h2>
                        </td>
                    </tr>
                    <tr>
                        <td>제조회사</td>
                        <td>${productInfo.company}</td>
                    </tr>
                    <tr>
                    	<td><strong>상품금액 합계</strong></td>
                    	<td>
                    		<h1 class="total_price">
                    			<fmt:formatNumber value="${productInfo.productPrice}" pattern="#,###" />원
                   			</h1>
                    	</td>
                    </tr>
                    <c:if test="${optionCount > 0}">
                    <tr>
                    	<td colspan='2'>
                        	<div class="selectbox">
	                            <select class="option" id="option" name="option" onchange="javascript:selectOption(this.options[this.selectedIndex].value);">
	                            	<option value="" data-price="${productInfo.productPrice}">선택 없음</option>
	                            	<c:forEach items="${optionList}" var="option">
                                	<option value="${option.stock}" 
                                			data-id="${option.productID}" 
                                			data-price="${option.productPrice}">
                                			${option.productName}
                              			</option>
	                                </c:forEach>
	                            </select>
                            </div>
                        </td>
                    </tr>
                    </c:if>
                </table>
                
                <div class="selectedInfo">
                	<h5 class="selectedOption">선택 없음</h5>
                	<p class="cartStock">
                        <button type="button" class="calc" id="minus">-</button>
                        <span style="text-align: center;">
                        	<input type="number" id="numBox" min="1" max="${productInfo.stock}" value="1" readonly="readonly" />
                        </span>
                        <button type="button" class="calc" id="plus">+</button>
                     </p>
                </div>
                
                <div class="btnDiv">
                	<button class="cartBtn" id="cartBtn">장바구니</button>
                    <button class="buyBtn" id="buyBtn">바로구매</button>
                </div>
            </div>
            
            <div class="optionImg">
	            <c:forEach items="${optionList}" var="optionImgUrl">
	            	<li class="option-img" data-src="${optionImgUrl.prodimgurl}">
	            		<img src="${optionImgUrl.prodimgurl}" />
            		</li>
	            </c:forEach>
            </div>
        </div>
        
        <div class="tab">
        	<div class="tabBtns">
	            <ul class="tabnav">
	                <li class="bottom-menu"><a href="#tab01">상품상세</a></li>
	                <li class="bottom-menu"><a href="#tab02">상품평</a></li>
	            </ul>
            </div>
            <div class="tabcontent">
                <div id="tab01">
                    <img class="productDetail" src="${productInfo.productDetail}">
                </div>
                <div id="tab02">
   					<input type="hidden" id="csrfToken" name="${_csrf.parameterName}" value="${_csrf.token}" />
   					
                    <!-- 상품평 -->
					<c:if test="${showWriteBtn == true}">
	                    <div>
	                        <button class="writeBtn" id="writeBtn">상품평 작성하기</button>
	                    </div>
	                    
	                    <div class="write-modal">
	                    	<input type="hidden" id="memberID" name="${memberDTO.id}" value="${memberDTO.id}">
	                    	<input type="hidden" id="productID" name="${orderProductID}" value="${orderProductID}">
	                        <h4 class="membername"><i class="fa-solid fa-heart" style="color: FF493C"></i>
	                        	<b>${memberDTO.name}</b>님, 이번 상품은 어떠셨나요?
	                       	</h4>
	                       	<textarea cols="34" rows="5" type="text" class="write-review-content" placeholder="상품평을 작성해주세요. (최대 2,000자)"></textarea>
	                       	<input type="file" name='uploadFile' style="margin-left: 30px; "multiple>
	                       	<div class='uploadResult'>
								<ul>
								
								</ul>
							</div>
	                       	<div class="review-buttons">
	                            <button type="button" class="review-button" id="cancelBtn">취소</button>
	                            <button type="button" class="review-button" id="finishBtn">작성 완료</button>
	                          </div>
	                    </div>
	                </c:if>
                    
                    <c:forEach items="${reviewList}" var="review">
	                    <div class="review" id="review">
	                        <div>
	                    		<input type="hidden" id="reviewID" name="${review.reviewID}" value="${review.reviewID}">
	                            <p class="review-profile-name">
	                            	${review.name}
		                        	<c:if test="${review.name == memberDTO.name}">
		                        		<button type="button" class="deleteBtn" id="deleteBtn" style="float: right;">삭제</button>
		                        	</c:if>
	                           		<span class="review-create-date">
		                            	<fmt:formatDate value="${review.createDate}" pattern="yyyy-MM-dd" />
									</span>
								</p>
	                            <p class="review-product-info">[${productInfo.productName}]&nbsp;&nbsp;${review.productName}</p>
	                            <p class="review-content">${review.content}</p>
                            
	                            <div class="imgList">
	                                <div class="imgC">
		                                <c:forEach items="${review.attachList}" var="attach">
		                                    <img class="reviewImg" src="${attach.imagePath}" alt="${attach.imagePath}">
	                                    </c:forEach>
	                                </div>
	                            </div>
	
	                            <!-- 상품평 이미지 팝업 -->
	                            <div class="modal">
	                                <button>&times;</button>
	                                <div class="modalBox">
	                                    <img src="" alt="">
	                                </div>
	                            </div>
	                        </div>
	                        <hr>
	                    </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
    
    <%@ include file="footer.jsp" %>
</body>
</html>