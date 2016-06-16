var app = angular.module('app', [])
    .controller('appController', function ($scope, $http) {
        var url = "http://localhost:8080/ws/question/all";

        $scope.getQuestion = function () {
            return 'view/question.html';
        };


        $http.get(url).success(
            function (data) {
                $scope.question = data;
            }
        );


    });