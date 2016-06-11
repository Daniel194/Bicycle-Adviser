var app = angular.module('app', [])
    .controller('appController', function ($scope, $http) {
        var url = "http://localhost:8080/ws/answer/";

        $scope.getQuestion = function () {
            return 'view/question.html';
        };

        $scope.sendAnswer = function () {
            var jsonUrl = url + $scope.answer;

            $http.get(jsonUrl).success(
                function (data) {
                    $scope.question = data.question;
                    $scope.options = data.options;
                }
            );
        };

    });