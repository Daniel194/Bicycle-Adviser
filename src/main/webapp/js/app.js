var app = angular.module('app', [])
    .controller('appController', function ($scope, $http) {
        var urlQuestion = "http://localhost:8080/ws/question/all";
        var count = 0;
        var questions = [];
        var responses = [];
        $scope.showQuestion = true;

        $http.get(urlQuestion).success(
            function (data) {
                questions = data;
                $scope.question = data[count];
            }
        );

        $scope.answer = function (answer) {
            responses.push({"value": questions[count].value, "answer": answer});

            if (count < questions.length - 1)
                $scope.question = questions[++count];
            else
                $scope.showQuestion = false;

        };

    });