export function reduceErrors(errors) {
    if (!Array.isArray(errors)) {
        errors = [errors];
    }

    let message = (
        errors
            .filter((error) => !!error)
            .map((error) => {
                if (Array.isArray(error.body)) {
                    return error.body.map((e) => e.message);
                }
                else if (error.body && typeof error.body.message === 'string') {
                    return error.body.message;
                }
                else if (typeof error.message === 'string') {
                    return error.message;
                } else if(error.statusText)
                    return error.statusText;
                else{
                    return error;
                }
            })
            .reduce((prev, curr) => prev.concat(curr), [])
            .filter((message) => !!message)
    );

    let error = errors[0];
    message = message + reduceError(error?.output?.fieldErrors);
    message = message + reduceError(error?.output?.pageErrors);
    message = message + reduceError(error?.output?.errors);
    message = message + reduceError(error?.body?.fieldErrors);
    message = message + reduceError(error?.body?.pageErrors);
    message = message + reduceError(error?.body?.errors);
    message = message + reduceError(error?.body?.output?.errors);
    message = message + reduceError(error?.body?.output?.fieldErrors);
    message = message + reduceError(error?.body?.output?.pageErrors);
    return message.toString();

    function reduceError(errors){
        if(!errors){
            return '';
        }
        let errorMsg  = ''; 
        for(const p in errors){
            if(errors[p]){
                let anError = errors[p];
                if (!Array.isArray(anError)) {
                    anError = [anError];
                }
                if(errorMsg){
                    errorMsg += '\n\r';
                }
                errorMsg = errorMsg + p + ' :: ' + anError.map(v1=>{
                    return v1.statusCode + ' : ' + v1.message;
                }).join(', ');    
            }
        };
        return errorMsg;
    }
}