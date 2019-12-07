Feature: Canada Only

  All PB resources must reside in Canada 

  Scenario Outline: Data Resdiency
    Given I have resource that supports tags defined
    When it contains location
    Then its value must be <validlocations>


  Examples:
    | validlocations | 
    | canadacentral  | 
    | canadaeast     | 