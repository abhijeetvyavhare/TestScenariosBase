public with sharing class BooleanEvaluate {

    private static final String ANDv = 'AND';
    private static final String ORv = 'OR';
    private static final String OPEN = '(';
    private static final String CLOSE = ')';

    private String expression;
    private Boolean[] values;

    public BooleanEvaluate(String expression, Boolean[] values){

        this.values = values;
        this.expression = expression.replaceAll('\\|\\|', 'OR').replaceAll('&&', 'AND');
        this.formatExpression();
    }

    public BooleanEvaluate(String expression, String[] arguments){

        expression = expression.replaceAll('\\|\\|', 'OR').replaceAll('&&', 'AND');
        this.expression = String.format( expression , arguments );
    }

    public static BooleanEvaluate allConditions(Boolean[] arguments){
        List<String> expressions = new List<String>();
        for(Boolean argument : arguments){
            expressions.add(String.valueOf(expressions.size() +1));
        }
        return new BooleanEvaluate(String.join(expressions, ' AND '), arguments);
    }

    public static BooleanEvaluate allConditions(String[] arguments){
        List<String> expressions = new List<String>();
        for(String argument : arguments){
            expressions.add('$'+ (expressions.size() +1));
        }
        return new BooleanEvaluate(String.join(expressions, ' AND '), arguments);
    }

    public static BooleanEvaluate anyConditions(Boolean[] arguments){
        List<String> expressions = new List<String>();
        for(Boolean argument : arguments){
            expressions.add(String.valueOf(expressions.size() +1));
        }
        return new BooleanEvaluate(String.join(expressions, ' OR '), arguments);
    }

    public static BooleanEvaluate anyConditions(String[] arguments){
        List<String> expressions = new List<String>();
        for(String argument : arguments){
            expressions.add('$'+ (expressions.size() +1));
        }
        return new BooleanEvaluate(String.join(expressions, ' OR '), arguments);
    }

    public Boolean evaluate(){

        return evaluate(this.expression);
    }

    private Boolean evaluate(String expression){
        
        if(!expression.contains(OPEN)){
            return evaluateExpression(expression);
        }

        Integer indexOfOpen = -1;
        Integer indexOfClose = -1;

        String[] chars = expression.split('');
        for(Integer i = 0; i < chars.size(); i++){

            String singleChar = chars[i];

            if(singleChar == OPEN) {
                indexOfOpen = i;
                continue;
            }

            if(singleChar == CLOSE) {
                indexOfClose = i;
                break;
            }
        }

        String replace = expression.substring(indexOfOpen + 1 , indexOfClose);
        expression = expression.replace( OPEN + replace + CLOSE, String.valueOf( evaluateExpression(replace) ) );
        return evaluate(expression);
    }

    private Boolean evaluateExpression(String expression){

        Boolean result = false;
        for( String conj : expression.split(ORv) ){

            Boolean b = true;
            for( String single : conj.split(ANDv) ){
                b &= Boolean.valueOf(single.trim());
            }

            result |= b;
        }

        return result;

    }

    private void formatExpression(){

        String[] arguments = this.expression.split(' ');
        for(String arg : arguments){
            try{
                Integer index = Integer.valueOf(arg);
                this.expression = this.expression.replace(arg, String.valueOf(this.values[index - 1]));
            }catch(Exception e){
                continue;
            }
        }
    }
}