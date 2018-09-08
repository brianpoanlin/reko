//
//  CGAffineTransform+ContentMode.swift
//  SvgViewer
//
//  Created by Vitali Kurlovich on 9/10/17.
//  Copyright © 2017 Vitali Kurlovich. All rights reserved.
//

import UIKit

extension CGAffineTransform {
    static func transformForMode(contentMode:UIViewContentMode, bounds:CGRect, contentBounds:CGRect)->CGAffineTransform {
        
        switch contentMode {
        case .scaleToFill, .redraw :
            return transformForScaleToFillMode(bounds, contentBounds)
            
        case .scaleAspectFit:
            return transformForScaleAspectFitMode(bounds, contentBounds)
            
        case .scaleAspectFill :
            return transformForScaleAspectFillMode(bounds, contentBounds)
            
        case .center :
            return transformForCenterMode(bounds, contentBounds)
            
        case .left :
            return transformForLeftMode(bounds, contentBounds)
            
        case .right :
            return transformForRightMode(bounds, contentBounds)
            
        case .top :
            return transformForTopMode(bounds, contentBounds)
            
        case .bottom :
            return transformForBottomMode(bounds, contentBounds)
            
        case .topLeft :
            return transformForTopLeftMode(bounds, contentBounds)
            
        case .topRight:
            return transformForTopRightMode(bounds, contentBounds)
            
        case .bottomLeft :
            return transformForBottomLeftMode(bounds, contentBounds)
            
        case .bottomRight :
            return transformForBottomRightMode(bounds, contentBounds)
        }
    }
    
    static private func transformForScaleToFillMode(_ bounds:CGRect, _ contentBounds:CGRect ) -> CGAffineTransform {
        return CGAffineTransform.identity
            .scaledBy(x: bounds.size.width/contentBounds.size.width, y: bounds.size.height/contentBounds.size.height)
            .translatedBy(x: -contentBounds.origin.x, y: -contentBounds.origin.y);
    }
    
    static private func transformForScaleAspectFitMode(_ bounds:CGRect, _ contentBounds:CGRect ) -> CGAffineTransform {
        let aspectWidth = bounds.size.width/contentBounds.size.width;
        let aspectHeight = bounds.size.height/contentBounds.size.height;
        
        var aspectScale = aspectWidth;
        
        if (contentBounds.height*aspectWidth > bounds.height) {
            aspectScale = aspectHeight;
        }
        
        return CGAffineTransform.identity
            .translatedBy(x: bounds.width/2, y: bounds.height/2)
            .scaledBy(x: aspectScale, y: aspectScale)
            .translatedBy(x: -contentBounds.minX - contentBounds.width/2, y: -contentBounds.minY - contentBounds.height/2);
    }
    
    static private func transformForScaleAspectFillMode(_ bounds:CGRect, _ contentBounds:CGRect ) -> CGAffineTransform  {
        
        let aspectWidth = bounds.width/contentBounds.width;
        let aspectHeight = bounds.height/contentBounds.height;
        
        var aspectScale = aspectWidth;
        
        if (contentBounds.height*aspectWidth < bounds.height) {
            aspectScale = aspectHeight;
        }
        
        return
            CGAffineTransform.identity
                .translatedBy(x: bounds.width/2, y: bounds.height/2)
                .scaledBy(x: aspectScale, y: aspectScale)
                .translatedBy(x: -contentBounds.minX - contentBounds.width/2, y: -contentBounds.minY - contentBounds.height/2)
    }
    
    static private func transformForCenterMode(_ bounds:CGRect, _ contentBounds:CGRect ) -> CGAffineTransform {
		
		let x = (bounds.width - contentBounds.width)/2 - contentBounds.minX
		let y = (bounds.height - contentBounds.height)/2 - contentBounds.minY
		
        return CGAffineTransform.identity
            .translatedBy(x:x, y:y)
    }
    
    static private func transformForLeftMode(_ bounds:CGRect, _ contentBounds:CGRect ) -> CGAffineTransform {
		let x = bounds.minX - contentBounds.minX
		let y = (bounds.height - contentBounds.height)/2 - contentBounds.minY
        return CGAffineTransform.identity
            .translatedBy(x:x, y:y)
    }
    
    static private func transformForRightMode(_ bounds:CGRect, _ contentBounds:CGRect ) -> CGAffineTransform {
        return CGAffineTransform.identity
            .translatedBy(x: -contentBounds.minX - contentBounds.width + bounds.width, y: -contentBounds.minY - contentBounds.height/2 + bounds.height/2)
    }
    
    static private func transformForTopMode(_ bounds:CGRect, _ contentBounds:CGRect ) -> CGAffineTransform {
        return CGAffineTransform.identity
            .translatedBy(x: -contentBounds.minX - contentBounds.width/2 + bounds.width/2, y: -contentBounds.minY)
    }
    
    static private func transformForBottomMode(_ bounds:CGRect, _ contentBounds:CGRect ) -> CGAffineTransform {
		let x = (bounds.width - contentBounds.width)/2 - contentBounds.minX
		let y = (bounds.height - contentBounds.height) - contentBounds.minY
		
        return CGAffineTransform.identity
            .translatedBy(x:x, y:y)
    }
    
    static private func transformForTopLeftMode(_ bounds:CGRect, _ contentBounds:CGRect ) -> CGAffineTransform {
        return CGAffineTransform.identity
			.translatedBy(x: -contentBounds.minX, y: -contentBounds.minY)
    }
    
    static private func transformForTopRightMode(_ bounds:CGRect, _ contentBounds:CGRect ) -> CGAffineTransform {
        return CGAffineTransform.identity
            .translatedBy(x: -contentBounds.minX - contentBounds.width + bounds.width, y: -contentBounds.minY)
    }
    
    static private func transformForBottomLeftMode(_ bounds:CGRect, _ contentBounds:CGRect ) -> CGAffineTransform  {
        return CGAffineTransform.identity
            .translatedBy(x: -contentBounds.minX, y: -contentBounds.minY - contentBounds.height + bounds.height)
    }
    
    static private func transformForBottomRightMode(_ bounds:CGRect, _ contentBounds:CGRect ) -> CGAffineTransform  {
        return CGAffineTransform.identity
            .translatedBy(x: -contentBounds.minX - contentBounds.width + bounds.width, y: -contentBounds.minY - contentBounds.height + bounds.height)
    }
}
