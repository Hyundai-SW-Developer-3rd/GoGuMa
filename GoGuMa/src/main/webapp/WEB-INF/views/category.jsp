<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="http://code.jquery.com/jquery-1.11.3.min.js"></script>
<script src="https://kit.fontawesome.com/a4f59ea730.js" crossorigin="anonymous"></script>

<head>
    <title>Category</title>
    <style>
	    <%@ include file="/resources/css/style.css" %>

        img {
            width: 220px;
            height: 220px;
            margin-left: 17.5px;
            margin-right: 17.5px;
        }

        .product {
            position: relative;
            width: 265px;
            height: 380px;
            margin: auto;
            float: left;
        }
    </style>
    <script>
        $(document).ready(function () {
            $('#searchBtn').click(function () {
                var keyword = $("#keyword").val();
                // 검색 키워드가 존재하지 않는다면 '검색할 상품명을 입력하세요' alert창 띄워주기
                if (keyword != '') {
                    // 검색 동작 코드 작성하기
                    alert(keyword);
                } else {
                    alert('검색할 상품명을 입력하세요.');
                }
                // 검색 input box "" 초기화하기
            });
        });
    </script>
</head>

<body>
	<%@ include file="header.jsp" %>

        <h2 style="text-align: center">카테고리ID</h2>

        <hr>

        <h4>총 ${count}개</h4>
		
        <div>
        	<c:forEach items="${list}" var="product">
            <div class="product">
                <p><img src="${product.prodimgurl}" /></p>
                <h4>${product.productName}</h4>
                <h3>${product.price}</h3>
            </div>
            </c:forEach>
        </div>
    </div>
</body>

</html>