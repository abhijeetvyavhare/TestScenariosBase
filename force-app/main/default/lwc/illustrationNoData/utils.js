export function isSmall(variant) {
    return typeof variant === 'string' && variant.toLowerCase() === 'small';
}

export function isLarge(variant) {
    return typeof variant === 'string' && variant.toLowerCase() === 'large';
}

export function isDesert(variant) {
    return typeof variant === 'string' && variant.toLowerCase() === 'desert';
}