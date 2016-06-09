var app = angular.module('app', [])
    .controller('appController', function ($scope, $http) {
        var jsonUrl = "http://localhost:8080/ws/answer/daniel";

        $http.get(jsonUrl).success(
            function (data) {
                $scope.question = data.question;
                $scope.options = data.options;
            }
        );

        $scope.getQuestion = function () {
            return 'view/question.html';
        };
    });