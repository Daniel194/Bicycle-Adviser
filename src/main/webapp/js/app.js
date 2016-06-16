var app = angular.module('app', [])
    .controller('appController', function ($scope, $http) {
        var url = "http://localhost:8080/ws/question/all";
        var count = 0;
        var questions = [];

        $http.get(url).success(
            function (data) {
                questions = data;
                $scope.question = data[count];
            }
        );

        $scope.answer = function (valeu) {
            $scope.question = questions[count++];
        };

    });